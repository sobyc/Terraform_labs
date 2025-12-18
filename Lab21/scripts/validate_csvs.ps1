param([string]$modulePath)

function IpToInt([string]$ip) {
    $parts = $ip -split '\.'
    if ($parts.Length -ne 4) { throw "Invalid IP: $ip" }
    $int = 0
    for ($i = 0; $i -lt 4; $i++) {
        $part = [int]$parts[$i]
        if ($part -lt 0 -or $part -gt 255) { throw "Invalid IP octet in $ip" }
        $int = $int -shl 8
        $int = $int -bor $part
    }
    return $int
}

function ParseCidr([string]$cidr) {
    if ($cidr -notmatch '^([0-9]{1,3}(?:\.[0-9]{1,3}){3})/(\d{1,2})$') { throw "Invalid CIDR syntax: $cidr" }
    $ip = $matches[1]
    $prefix = [int]$matches[2]
    if ($prefix -lt 0 -or $prefix -gt 32) { throw "Invalid CIDR prefix: $cidr" }
    $ipInt = IpToInt $ip
    $size = [math]::Pow(2, 32 - $prefix)
    # compute network start aligned to size
    $start = [math]::Floor($ipInt / $size) * $size
    $end = $start + $size - 1
    return @{ip=$ip; prefix=$prefix; start=[uint64]$start; end=[uint64]$end; cidr=$cidr}
}

$errors = @()

# files to check (per-environment CSVs only)
$files = @{
    vnets_prod = Join-Path $modulePath "vnets.prod.csv"
    subnets_prod = Join-Path $modulePath "subnets.prod.csv"
    vnets_dev = Join-Path $modulePath "vnets.dev.csv"
    subnets_dev = Join-Path $modulePath "subnets.dev.csv"
}

# helper to read CSV if exists
function ReadCsvIfExists([string]$path) {
    if (Test-Path $path) {
        try { return Import-Csv -Path $path } catch { throw "Unable to read CSV ${path}: $_" }
    } else { return @() }
}

$vnets_all = @()
$vnets_all += ReadCsvIfExists $files.vnets_prod
$vnets_all += ReadCsvIfExists $files.vnets_dev

$subnets_all = @()
$subnets_all += ReadCsvIfExists $files.subnets_prod
$subnets_all += ReadCsvIfExists $files.subnets_dev

# required fields
foreach ($r in $vnets_all) {
    if (-not $r.role -or -not $r.address_space) { $errors += "vnets CSV row missing required fields (role,address_space): $($r | ConvertTo-Csv -NoTypeInformation)" }
}
foreach ($r in $subnets_all) {
    if (-not $r.role -or (-not $r.subnet_name -and -not $r.subnet_role)) { $errors += "subnets CSV row missing required fields (role, subnet_name|subnet_role): $($r | ConvertTo-Csv -NoTypeInformation)" }
}

# validate CIDRs and build per-env lists
$vnets_prod = ReadCsvIfExists $files.vnets_prod
$vnets_dev  = ReadCsvIfExists $files.vnets_dev

function ValidateVnets([array]$list, [string]$env) {
    $parsed = @()
    foreach ($v in $list) {
        try {
            $cidr = $v.address_space
            $p = ParseCidr $cidr
            $parsed += @{name = ($v.name -or $v.role); cidr = $cidr; start = $p.start; end = $p.end}
        } catch {
            $errors += "Invalid CIDR in vnets ($env): $cidr -> $_"
        }
    }
    # overlap detection
    for ($i=0; $i -lt $parsed.Count; $i++) {
        for ($j=$i+1; $j -lt $parsed.Count; $j++) {
            $a = $parsed[$i]; $b = $parsed[$j]
            if (-not ($a.end -lt $b.start -or $b.end -lt $a.start)) {
                $errors += "CIDR overlap detected in $env between $($a.cidr) and $($b.cidr)"
            }
        }
    }
}

# Compute derived subnet CIDR for a given vnet cidr, newbits and index (mimics Terraform cidrsubnet behavior)
function ComputeDerivedCidr([string]$vnetCidr, [int]$newbits, [int]$index) {
    $p = ParseCidr $vnetCidr
    $subnetPrefix = $p.prefix + $newbits
    if ($subnetPrefix -gt 32) { throw "Invalid derived prefix $subnetPrefix for $vnetCidr" }
    $sizeSubnet = [math]::Pow(2, 32 - $subnetPrefix)
    $subnetStart = $p.start + ($index * $sizeSubnet)
    if ($subnetStart -gt ($p.end)) { throw "Index $index out of range for $vnetCidr with newbits $newbits" }
    # convert int to dotted decimal
    $a = ($subnetStart -band 0xFF000000) -shr 24
    $b = ($subnetStart -band 0x00FF0000) -shr 16
    $c = ($subnetStart -band 0x0000FF00) -shr 8
    $d = ($subnetStart -band 0x000000FF)
    $ip = "$a.$b.$c.$d"
    $end = $subnetStart + $sizeSubnet - 1
    return @{cidr = "$ip/$subnetPrefix"; start = [uint64]$subnetStart; end = [uint64]$end}
}

function ValidateSubnets([array]$vnets, [array]$subnets_env, [string]$env) {
    $parsed = @()
    $defaults = @("app","web","db","test")
    foreach ($v in $vnets) {
        $rowsForRole = $subnets_env | Where-Object { $_.role -eq $v.role }
        if ($rowsForRole.Count -gt 0) {
            $names = $rowsForRole | ForEach-Object { if ($_.subnet_name) { $_.subnet_name } elseif ($_.subnet_role) { $_.subnet_role } else { $null } } | Where-Object { $_ } | Sort-Object -Unique
            $idx = 0
            foreach ($name in $names) {
                $row = $rowsForRole | Where-Object { ($_.subnet_name -eq $name) -or ($_.subnet_role -eq $name) } | Select-Object -First 1
                if ($row.subnet_cidr) {
                    try { $p = ParseCidr $row.subnet_cidr; $parsed += @{vnet=$v.name; name=$name; cidr=$row.subnet_cidr; start=$p.start; end=$p.end} } catch { $errors += "Invalid CIDR in subnets ($env) for role $($v.role): $($row.subnet_cidr) -> $_" }
                } else {
                    try { $d = ComputeDerivedCidr $v.address_space 8 $idx; $parsed += @{vnet=$v.name; name=$name; cidr=$d.cidr; start=$d.start; end=$d.end} } catch { $errors += "Unable to compute derived CIDR for $($v.role)/$name in " + $env + ": " + $_ }
                }
                $idx++
            }
        } else {
            for ($idx=0; $idx -lt $defaults.Count; $idx++) {
                try { $d = ComputeDerivedCidr $v.address_space 8 $idx; $parsed += @{vnet=$v.name; name=$defaults[$idx]; cidr=$d.cidr; start=$d.start; end=$d.end} } catch { $errors += "Unable to compute default derived CIDR for $($v.role) in " + $env + ": " + $_ }
            }
        }
    }

    # overlap detection for subnets
    for ($i=0; $i -lt $parsed.Count; $i++) {
        for ($j=$i+1; $j -lt $parsed.Count; $j++) {
            $a = $parsed[$i]; $b = $parsed[$j]
            if (-not ($a.end -lt $b.start -or $b.end -lt $a.start)) {
                $errors += "CIDR overlap detected between subnets in " + $env + ": " + $a.vnet + "/" + $a.cidr + " overlaps " + $b.vnet + "/" + $b.cidr
            }
        }
    }
}

$subnets_prod = ReadCsvIfExists $files.subnets_prod
$subnets_dev  = ReadCsvIfExists $files.subnets_dev

ValidateVnets $vnets_prod "prod"
ValidateVnets $vnets_dev  "dev"
ValidateSubnets $vnets_prod $subnets_prod "prod"
ValidateSubnets $vnets_dev  $subnets_dev  "dev"

if ($errors.Count -gt 0) {
    foreach ($e in $errors) { Write-Error $e }
    exit 1
} else {
    @{ok = "true"} | ConvertTo-Json -Compress
    exit 0
}