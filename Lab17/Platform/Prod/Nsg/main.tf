

locals {
  nsg_raw = csvdecode(file(var.nsg_csv_path))

  nsg = {
    for row in local.nsg_raw :
    trimspace(try(row.name, "")) => {
      name = trimspace(try(row.name, ""))

      resource_group = (
        length(trimspace(try(row.resource_group, ""))) > 0
        ? trimspace(row.resource_group)
        : coalesce(var.default_resource_group_name, "")
      )

      network_security_group_name = (
        length(trimspace(try(row.network_security_group_name, ""))) > 0
        ? trimspace(row.network_security_group_name)
        : coalesce(var.default_network_security_group_name, "")
      )
      location = (
        length(trimspace(try(row.location, ""))) > 0
        ? trimspace(row.location)
        : coalesce(var.default_location, "")
      )

    }
  }
}

# Tags: "k=v;k2=v2" → map. Guard against malformed entries.


# Fail-fast validation for required fields
locals {
  invalid_rows = [
    for k, v in local.nsg :
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

}

module "nsgassociations" {
  source                  = "./nsgassociation"
  nsgassociation_csv_path = "${path.root}/Platform/Prod/Nsg/nsgassociation/nsgassociation.csv"
  depends_on              = [azurerm_network_security_group.this]
}


module "nsgrules" {
  source = "./nsgrules"

  nsg_rules_csv_path = "${path.root}/Platform/Prod/Nsg/nsgrules/nsgrules.csv"

  depends_on = [
    azurerm_network_security_group.this
  ]
}