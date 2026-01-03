
locals {
  vnets_raw = csvdecode(file(var.vnet_csv_path))

  vnets = {
    for row in local.vnets_raw :
    trimspace(try(row.name, "")) => {
      name = trimspace(try(row.name, ""))

      resource_group = (
        length(trimspace(try(row.resource_group, ""))) > 0
        ? trimspace(row.resource_group)
        : coalesce(var.default_resource_group_name, "")
      )

      location = (
        length(trimspace(try(row.location, ""))) > 0
        ? trimspace(row.location)
        : coalesce(var.default_location, "")
      )

      # Semicolon-separated CIDRs
      address_space = [
        for cidr in split(";", trimspace(try(row.address_space, "")))
        : trimspace(cidr)
        if length(trimspace(cidr)) > 0
      ]

      # Optional semicolon-separated DNS servers
      dns_servers = [
        for ip in split(";", trimspace(try(row.dns_servers, "")))
        : trimspace(ip)
        if length(trimspace(ip)) > 0
      ]

      # Tags: "k=v;k2=v2" → map. Guard against malformed entries.
      tags = merge(
        var.common_tags,
        {
          for kv in split(";", trimspace(try(row.tags, ""))) :
          trimspace(split(kv, "=")[0]) =>
          (
            length(split(kv, "=")) > 1
            ? trimspace(split(kv, "=")[1])
            : ""
          )
          if length(trimspace(kv)) > 0 && length(split(kv, "=")) > 1
        }
      )
    }
    if length(trimspace(try(row.name, ""))) > 0
  }
}


# Fail-fast validation for required fields
locals {
  invalid_rows = [
    for k, v in local.vnets :
    k if(
      length(v.resource_group) == 0 ||
      length(v.location) == 0 ||
      length(v.address_space) == 0
    )
  ]
}

# Emit a clear validation error before planning resources
resource "null_resource" "validate_vnet_rows" {
  count = length(local.invalid_rows) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid VNet rows (missing RG/location/address_space): ${join(",", local.invalid_rows)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create VNets
resource "azurerm_virtual_network" "this" {
  for_each            = local.vnets
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group

  address_space = each.value.address_space

  # For azurerm >= 3.x, empty list is fine; if your provider rejects null, use [].
  dns_servers = length(each.value.dns_servers) > 0 ? each.value.dns_servers : []

  tags = each.value.tags

}

module "vnet_peering" {
  source = "./vnetpeer"

  depends_on = [azurerm_virtual_network.this]

  vnet_peering_csv_path = "${path.root}/Platform/Prod/Vnet/vnetpeer/vnetpeer.csv"
}