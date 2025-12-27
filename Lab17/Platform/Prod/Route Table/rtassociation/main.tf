

locals {
  rtassociation_raw = csvdecode(file(var.rtassociation_csv_path))

  subnet_associations = {
    for row in local.rtassociation_raw :
    "${row.subnet_id}|${row.route_table_id}" => row
  }
}


resource "azurerm_subnet_route_table_association" "subnet" {
  for_each = local.subnet_associations

  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}


# Tags: "k=v;k2=v2" → map. Guard against malformed entries.

/*
# Fail-fast validation for required fields
locals {
  invalid_rows = [
    for k, v in local.nsg:
    k if(
      length(v.resource_group) == 0 ||
      length(v.network_security_group_name) == 0 ||
      length(v.location) == 0
    )
  ]
}

# Emit a clear validation error before planning resources
resource "null_resource" "validate_nsg_rows" {
  count = length(local.invalid_rows) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid Network Security Group rows (missing RG/network_security_group_name/location): ${join(",", local.invalid_rows)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create Network Security Groups
resource "azurerm_network_security_group" "this" {
  for_each            = local.nsg
  name                = each.value.name
  resource_group_name = each.value.resource_group
  location            = each.value.location

}*/
