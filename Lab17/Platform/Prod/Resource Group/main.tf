

locals {
  rg_raw = csvdecode(file(var.rg_csv_path))

  resource_group = {
    for row in local.rg_raw :
    trimspace(try(row.name, "")) => {
      name = trimspace(try(row.name, ""))

      resource_group = (
        length(trimspace(try(row.name, ""))) > 0
        ? trimspace(row.name)
        : coalesce(var.default_resource_group_name, "")
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
    for k, v in local.resource_group :
    k if(
      length(v.name) == 0 ||
      length(v.location) == 0
    )
  ]
}

# Emit a clear validation error before planning resources
resource "null_resource" "validate_rg_rows" {
  count = length(local.invalid_rows) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid Resource Group rows (missing resource_group/location): ${join(",", local.invalid_rows)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create Resource Groups
resource "azurerm_resource_group" "this" {
  for_each = local.resource_group
  name     = each.value.name
  location = each.value.location

}
