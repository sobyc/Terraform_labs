
terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "7a0bf087-e2b9-4fb2-bb79-4ef863e0c025"

}

locals {
  subnet_newbits       = 8
  default_subnet_names = ["app", "web", "db", "test"]

  # Global CSVs
  vnets_csv_global   = csvdecode(file("${path.module}/vnets.csv"))
  subnets_csv_global = csvdecode(file("${path.module}/subnets.csv"))

  # Optional per-environment CSVs (take precedence when present)
  vnets_csv_prod = fileexists("${path.module}/vnets.prod.csv") ? csvdecode(file("${path.module}/vnets.prod.csv")) : []
  vnets_csv_dev  = fileexists("${path.module}/vnets.dev.csv") ? csvdecode(file("${path.module}/vnets.dev.csv")) : []

  subnets_csv_prod = fileexists("${path.module}/subnets.prod.csv") ? csvdecode(file("${path.module}/subnets.prod.csv")) : []
  subnets_csv_dev  = fileexists("${path.module}/subnets.dev.csv") ? csvdecode(file("${path.module}/subnets.dev.csv")) : []

  # Build merged per-environment CSV lists (per-env file rows first, then global rows targeting the env or all envs)
  vnets_csv_for_prod = concat(local.vnets_csv_prod, [for r in local.vnets_csv_global : r if lookup(r, "env", "") == "" || lower(lookup(r, "env", "")) == "prod"])
  vnets_csv_for_dev  = concat(local.vnets_csv_dev,  [for r in local.vnets_csv_global : r if lookup(r, "env", "") == "" || lower(lookup(r, "env", "")) == "dev"])

  subnets_csv_for_prod = concat(local.subnets_csv_prod, [for r in local.subnets_csv_global : r if lookup(r, "env", "") == "" || lower(lookup(r, "env", "")) == "prod"])
  subnets_csv_for_dev  = concat(local.subnets_csv_dev,  [for r in local.subnets_csv_global : r if lookup(r, "env", "") == "" || lower(lookup(r, "env", "")) == "dev"])

  # Normalize CSV rows into structured vnet objects per environment
  vnets_from_csv_for_prod = [for r in local.vnets_csv_for_prod : {
    role                = r.role
    name                = r.name
    address_space       = [r.address_space]
    location            = coalesce(r.location, var.location)
    resource_group_role = r.role
    env                 = lookup(r, "env", "")
  }]

  vnets_from_csv_for_dev = [for r in local.vnets_csv_for_dev : {
    role                = r.role
    name                = r.name
    address_space       = [r.address_space]
    location            = coalesce(r.location, var.location)
    resource_group_role = r.role
    env                 = lookup(r, "env", "")
  }]

  vnets_with_name_for_prod = [for v in local.vnets_from_csv_for_prod : merge(v, { name = coalesce(v.name, format("vnet-%s-%s-%s", var.region, v.role, "auto")), env = v.env })]
  vnets_with_name_for_dev  = [for v in local.vnets_from_csv_for_dev  : merge(v, { name = coalesce(v.name, format("vnet-%s-%s-%s", var.region, v.role, "auto")), env = v.env })]

  # Build per-environment vnet lists (deduped by name to avoid duplicate creations)
  vnets_for_prod = [
    for name in distinct([for v in local.vnets_with_name_for_prod : v.name]) :
      element([for v in local.vnets_with_name_for_prod : v if v.name == name], 0)
  ]
  vnets_for_dev = [
    for name in distinct([for v in local.vnets_with_name_for_dev : v.name]) :
      element([for v in local.vnets_with_name_for_dev : v if v.name == name], 0)
  ]

  # Build per-environment subnet lists aligned to vnets_for_prod / vnets_for_dev
  subnets_per_vnet_for_prod = [
    for v in local.vnets_for_prod : (
      length([for r in local.subnets_csv_for_prod : r if r.role == v.role]) > 0 ? [
        for idx, sname in distinct(sort([for rr in local.subnets_csv_for_prod : coalesce(rr.subnet_name, rr.subnet_role) if rr.role == v.role])) : {
          name = sname
          # Prefer per-env row matching v.env, fallback to global row (env == "") then derive
          address_prefix = lookup(element(concat([for rr in local.subnets_csv_for_prod : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == lower(v.env)], [for rr in local.subnets_csv_for_prod : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == ""]), 0), "subnet_cidr", "") != "" ? lookup(element(concat([for rr in local.subnets_csv_for_prod : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == lower(v.env)], [for rr in local.subnets_csv_for_prod : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == ""]), 0), "subnet_cidr", "") : cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
      ] : [
        for idx, sname in local.default_subnet_names : {
          name           = sname
          address_prefix = cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
      ]
    )
  ]

  subnets_per_vnet_for_dev = [
    for v in local.vnets_for_dev : (
      length([for r in local.subnets_csv_for_dev : r if r.role == v.role]) > 0 ? [
        for idx, sname in distinct(sort([for rr in local.subnets_csv_for_dev : coalesce(rr.subnet_name, rr.subnet_role) if rr.role == v.role])) : {
          name = sname
          # Prefer per-env row matching v.env, fallback to global row (env == "") then derive
          address_prefix = lookup(element(concat([for rr in local.subnets_csv_for_dev : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == lower(v.env)], [for rr in local.subnets_csv_for_dev : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == ""]), 0), "subnet_cidr", "") != "" ? lookup(element(concat([for rr in local.subnets_csv_for_dev : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == lower(v.env)], [for rr in local.subnets_csv_for_dev : rr if rr.role == v.role && lower(lookup(rr, "env", "")) == ""]), 0), "subnet_cidr", "") : cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
      ] : [
        for idx, sname in local.default_subnet_names : {
          name           = sname
          address_prefix = cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
      ]
    )
  ]

  # CSV validation: required columns (across global + per-env CSVs)
  vnets_all_rows = concat(local.vnets_csv_global, local.vnets_csv_prod, local.vnets_csv_dev)
  subnets_all_rows = concat(local.subnets_csv_global, local.subnets_csv_prod, local.subnets_csv_dev)

  vnets_missing_required = [for r in local.vnets_all_rows : r if trimspace(coalesce(lookup(r, "role", ""), "")) == "" || trimspace(coalesce(lookup(r, "address_space", ""), "")) == ""]
  subnets_missing_required = [for r in local.subnets_all_rows : r if trimspace(coalesce(lookup(r, "role", ""), "")) == "" || (trimspace(coalesce(lookup(r, "subnet_name", ""), "")) == "" && trimspace(coalesce(lookup(r, "subnet_role", ""), "")) == "")]

  # Invalid CIDRs and overlap detection per environment (stronger overlap detection: true interval overlap)
  invalid_vnets_cidr_prod = [for v in local.vnets_from_csv_for_prod : v.address_space[0] if !can(cidrhost(v.address_space[0], 1))]
  invalid_vnets_cidr_dev  = [for v in local.vnets_from_csv_for_dev  : v.address_space[0] if !can(cidrhost(v.address_space[0], 1))]

  vnet_parsed_for_prod = [for v in local.vnets_from_csv_for_prod : {
    name   = coalesce(v.name, v.role)
    cidr   = v.address_space[0]
    ip     = split("/", v.address_space[0])[0]
    prefix = tonumber(split("/", v.address_space[0])[1])
    start  = floor((element(split(".", split("/", v.address_space[0])[0]), 0) * 16777216 + element(split(".", split("/", v.address_space[0])[0]), 1) * 65536 + element(split(".", split("/", v.address_space[0])[0]), 2) * 256 + element(split(".", split("/", v.address_space[0])[0]), 3)) / pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))) * pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))
    end    = floor((element(split(".", split("/", v.address_space[0])[0]), 0) * 16777216 + element(split(".", split("/", v.address_space[0])[0]), 1) * 65536 + element(split(".", split("/", v.address_space[0])[0]), 2) * 256 + element(split(".", split("/", v.address_space[0])[0]), 3)) / pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))) * pow(2, 32 - tonumber(split("/", v.address_space[0])[1])) + pow(2, 32 - tonumber(split("/", v.address_space[0])[1])) - 1
  } if can(cidrhost(v.address_space[0], 1))]

  vnet_parsed_for_dev = [for v in local.vnets_from_csv_for_dev : {
    name   = coalesce(v.name, v.role)
    cidr   = v.address_space[0]
    ip     = split("/", v.address_space[0])[0]
    prefix = tonumber(split("/", v.address_space[0])[1])
    start  = floor((element(split(".", split("/", v.address_space[0])[0]), 0) * 16777216 + element(split(".", split("/", v.address_space[0])[0]), 1) * 65536 + element(split(".", split("/", v.address_space[0])[0]), 2) * 256 + element(split(".", split("/", v.address_space[0])[0]), 3)) / pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))) * pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))
    end    = floor((element(split(".", split("/", v.address_space[0])[0]), 0) * 16777216 + element(split(".", split("/", v.address_space[0])[0]), 1) * 65536 + element(split(".", split("/", v.address_space[0])[0]), 2) * 256 + element(split(".", split("/", v.address_space[0])[0]), 3)) / pow(2, 32 - tonumber(split("/", v.address_space[0])[1]))) * pow(2, 32 - tonumber(split("/", v.address_space[0])[1])) + pow(2, 32 - tonumber(split("/", v.address_space[0])[1])) - 1
  } if can(cidrhost(v.address_space[0], 1))]

  overlaps_prod = flatten([
    for i, a in local.vnet_parsed_for_prod : [
      for j, b in local.vnet_parsed_for_prod : j > i && !(a.end < b.start || b.end < a.start) ? [{ a = a.name, a_cidr = a.cidr, b = b.name, b_cidr = b.cidr }] : []
    ]
  ])

  overlaps_dev = flatten([
    for i, a in local.vnet_parsed_for_dev : [
      for j, b in local.vnet_parsed_for_dev : j > i && !(a.end < b.start || b.end < a.start) ? [{ a = a.name, a_cidr = a.cidr, b = b.name, b_cidr = b.cidr }] : []
    ]
  ])

  # For environments we already run validation via the external PowerShell script. Keep these computed errors for informational use (no-op here because the external script enforces failure).
  csv_error_vnets_missing = length(local.vnets_missing_required) > 0 ? format("vnets.csv missing required values (role,address_space): %s", tostring(local.vnets_missing_required)) : null
  csv_error_subnets_missing = length(local.subnets_missing_required) > 0 ? format("subnets.csv missing required values (role,subnet_name|subnet_role): %s", tostring(local.subnets_missing_required)) : null
  csv_error_invalid_cidr_prod = length(local.invalid_vnets_cidr_prod) > 0 ? format("Invalid CIDR in vnets.csv (prod): %s", tostring(local.invalid_vnets_cidr_prod)) : null
  csv_error_invalid_cidr_dev = length(local.invalid_vnets_cidr_dev) > 0 ? format("Invalid CIDR in vnets.csv (dev): %s", tostring(local.invalid_vnets_cidr_dev)) : null
  csv_error_overlaps_vnets_prod = length(local.overlaps_prod) > 0 ? format("CIDR overlap detected between VNets (prod): %s", jsonencode(local.overlaps_prod)) : null
  csv_error_overlaps_vnets_dev = length(local.overlaps_dev) > 0 ? format("CIDR overlap detected between VNets (dev): %s", jsonencode(local.overlaps_dev)) : null

  # Build parsed subnets (from computed per-vnet lists) so we can detect overlaps when users provide explicit subnet CIDRs
  parsed_subnets_prod = flatten([for idx_v, v in local.vnets_for_prod : [for s in local.subnets_per_vnet_for_prod[idx_v] : {
    vnet = v.name
    cidr = s.address_prefix
    ip = split("/", s.address_prefix)[0]
    prefix = tonumber(split("/", s.address_prefix)[1])
    start = floor((element(split(".", split("/", s.address_prefix)[0]), 0) * 16777216 + element(split(".", split("/", s.address_prefix)[0]), 1) * 65536 + element(split(".", split("/", s.address_prefix)[0]), 2) * 256 + element(split(".", split("/", s.address_prefix)[0]), 3)) / pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))) * pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))
    end = floor((element(split(".", split("/", s.address_prefix)[0]), 0) * 16777216 + element(split(".", split("/", s.address_prefix)[0]), 1) * 65536 + element(split(".", split("/", s.address_prefix)[0]), 2) * 256 + element(split(".", split("/", s.address_prefix)[0]), 3)) / pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))) * pow(2, 32 - tonumber(split("/", s.address_prefix)[1])) + pow(2, 32 - tonumber(split("/", s.address_prefix)[1])) - 1
  } if can(cidrhost(s.address_prefix, 1))]])

  overlaps_subnets_prod = flatten([
    for i, a in local.parsed_subnets_prod : [
      for j, b in local.parsed_subnets_prod : j > i && !(a.end < b.start || b.end < a.start) ? [{ a = a.vnet, a_cidr = a.cidr, b = b.vnet, b_cidr = b.cidr }] : []
    ]
  ])

  parsed_subnets_dev = flatten([for idx_v, v in local.vnets_for_dev : [for s in local.subnets_per_vnet_for_dev[idx_v] : {
    vnet = v.name
    cidr = s.address_prefix
    ip = split("/", s.address_prefix)[0]
    prefix = tonumber(split("/", s.address_prefix)[1])
    start = floor((element(split(".", split("/", s.address_prefix)[0]), 0) * 16777216 + element(split(".", split("/", s.address_prefix)[0]), 1) * 65536 + element(split(".", split("/", s.address_prefix)[0]), 2) * 256 + element(split(".", split("/", s.address_prefix)[0]), 3)) / pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))) * pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))
    end = floor((element(split(".", split("/", s.address_prefix)[0]), 0) * 16777216 + element(split(".", split("/", s.address_prefix)[0]), 1) * 65536 + element(split(".", split("/", s.address_prefix)[0]), 2) * 256 + element(split(".", split("/", s.address_prefix)[0]), 3)) / pow(2, 32 - tonumber(split("/", s.address_prefix)[1]))) * pow(2, 32 - tonumber(split("/", s.address_prefix)[1])) + pow(2, 32 - tonumber(split("/", s.address_prefix)[1])) - 1
  } if can(cidrhost(s.address_prefix, 1))]])

  overlaps_subnets_dev = flatten([
    for i, a in local.parsed_subnets_dev : [
      for j, b in local.parsed_subnets_dev : j > i && !(a.end < b.start || b.end < a.start) ? [{ a = a.vnet, a_cidr = a.cidr, b = b.vnet, b_cidr = b.cidr }] : []
    ]
  ])

  csv_error_subnet_overlaps_prod = length(local.overlaps_subnets_prod) > 0 ? format("CIDR overlap detected between subnets (prod): %s", jsonencode(local.overlaps_subnets_prod)) : null
  csv_error_subnet_overlaps_dev = length(local.overlaps_subnets_dev) > 0 ? format("CIDR overlap detected between subnets (dev): %s", jsonencode(local.overlaps_subnets_dev)) : null

  csv_validation_error = coalesce(local.csv_error_vnets_missing, local.csv_error_subnets_missing, local.csv_error_invalid_cidr_prod, local.csv_error_invalid_cidr_dev, local.csv_error_overlaps_vnets_prod, local.csv_error_overlaps_vnets_dev, local.csv_error_subnet_overlaps_prod, local.csv_error_subnet_overlaps_dev, null)
}

# Run CSV validation via external script (PowerShell). This will fail planning if CSVs are invalid.
data "external" "csv_validation" {
  program = ["powershell", "-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "${path.module}/scripts/validate_csvs.ps1", "${path.module}"]
}

module "env" {
  source           = "./env/prod/ci"
  vnets_with_name  = local.vnets_for_prod
  subnets_per_vnet = local.subnets_per_vnet_for_prod
  depends_on       = [data.external.csv_validation]
}


module "env-dev" {
  source           = "./env/dev/ci"
  vnets_with_name  = local.vnets_for_dev
  subnets_per_vnet = local.subnets_per_vnet_for_dev
  depends_on       = [data.external.csv_validation]
}