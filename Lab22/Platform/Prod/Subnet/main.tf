

locals {
  subnets_raw = csvdecode(file(var.subnet_csv_path))

  subnets = {
    for row in local.subnets_raw :
    trimspace(try(row.name, "")) => {
      name = trimspace(try(row.name, ""))

      resource_group = (
        length(trimspace(try(row.resource_group, ""))) > 0
        ? trimspace(row.resource_group)
        : coalesce(var.default_resource_group_name, "")
      )

      virtual_network_name = (
        length(trimspace(try(row.virtual_network_name, ""))) > 0
        ? trimspace(row.virtual_network_name)
        : coalesce(var.default_virtual_network_name, "")
      )

      # Semicolon-separated CIDRs
      address_space = [
        for cidr in split(";", trimspace(try(row.address_space, "")))
        : trimspace(cidr)
        if length(trimspace(cidr)) > 0
      ]
    }
  }
}

# Tags: "k=v;k2=v2" → map. Guard against malformed entries.


# Fail-fast validation for required fields
locals {
  invalid_rows = [
    for k, v in local.subnets :
    k if(
      length(v.resource_group) == 0 ||
      length(v.virtual_network_name) == 0 ||
      length(v.address_space) == 0
    )
  ]
}

# Emit a clear validation error before planning resources
resource "null_resource" "validate_subnet_rows" {
  count = length(local.invalid_rows) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid Subnet rows (missing RG/virtual_network_name/address_space): ${join(",", local.invalid_rows)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create VNets
resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group
  address_prefixes     = each.value.address_space

}
