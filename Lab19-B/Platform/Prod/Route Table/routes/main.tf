locals {
  route_rules_raw = csvdecode(file(var.route_rules_csv_path))

  route_rules = {
    for rule in local.route_rules_raw :
    "${rule.route_table_name}-${rule.route_name}" => rule
  }
}

resource "azurerm_route" "custom" {
  for_each = local.route_rules

  name                = each.value.route_name
  resource_group_name = each.value.resource_group
  route_table_name    = each.value.route_table_name
  address_prefix      = each.value.address_prefix
  next_hop_type       = each.value.next_hop_type

  next_hop_in_ip_address = (
    each.value.next_hop_type == "VirtualAppliance"
    ? each.value.next_hop_ip
    : null
  )
}

locals {
  invalid_routes = [
    for k, v in local.route_rules :
    k if(
      v.route_table_name == "" ||
      v.route_name == "" ||
      v.address_prefix == "" ||
      v.next_hop_type == "" ||
      (v.next_hop_type == "VirtualAppliance" && v.next_hop_ip == "")
    )
  ]
}

resource "null_resource" "validate_routes" {
  count = length(local.invalid_routes) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid route rows: ${join(",", local.invalid_routes)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}

locals {
  allowed_next_hops = [
    "Internet",
    "VirtualAppliance",
    "VirtualNetworkGateway",
    "VnetLocal",
    "None"
  ]

  invalid_next_hops = [
    for k, v in local.route_rules :
    k if !contains(local.allowed_next_hops, v.next_hop_type)
  ]
}