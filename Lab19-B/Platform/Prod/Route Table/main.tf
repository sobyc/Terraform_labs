

locals {
  rt_raw = csvdecode(file(var.rt_csv_path))

  rt = {
    for row in local.rt_raw :
    trimspace(try(row.name, "")) => {
      name = trimspace(try(row.name, ""))

      resource_group = (
        length(trimspace(try(row.resource_group, ""))) > 0
        ? trimspace(row.resource_group)
        : coalesce(var.default_resource_group_name, "")
      )

      route_table_name = (
        length(trimspace(try(row.route_table_name, ""))) > 0
        ? trimspace(row.route_table_name)
        : coalesce(var.default_route_table_name, "")
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
    for k, v in local.rt :
    k if(
      length(v.resource_group) == 0 ||
      length(v.route_table_name) == 0 ||
      length(v.location) == 0
    )
  ]
}

# Emit a clear validation error before planning resources
resource "null_resource" "validate_rt_rows" {
  count = length(local.invalid_rows) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid Route Table rows (missing RG/route_table_name/address_space): ${join(",", local.invalid_rows)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create Route Tables
resource "azurerm_route_table" "this" {
  for_each            = local.rt
  name                = each.value.name
  resource_group_name = each.value.resource_group
  location            = each.value.location

}


module "rtassociations" {
  source                 = "./rtassociation"
  rtassociation_csv_path = "${path.root}/Platform/Prod/Route Table/rtassociation/rtassociation.csv"
  depends_on = [
    azurerm_route_table.this
  ]
}


module "route_rules" {
  source = "./routes"

  route_rules_csv_path = "${path.root}/Platform/Prod/Route Table/routes/routes.csv"

  depends_on = [
    azurerm_route_table.this
  ]
}