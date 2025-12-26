

locals {
  nsg_rules_raw = csvdecode(file(var.nsg_rules_csv_path))

  nsg_rules = {
    for rule in local.nsg_rules_raw :
    "${rule.nsg_name}-${rule.rule_name}" => rule
  }
}

resource "azurerm_network_security_rule" "custom" {
  for_each = local.nsg_rules

  name      = each.value.rule_name
  priority  = tonumber(each.value.priority)
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol

  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  resource_group_name         = each.value.resource_group
  network_security_group_name = each.value.nsg_name
}


locals {
  invalid_rules = [
    for k, v in local.nsg_rules :
    k if(
      v.priority == "" ||
      v.nsg_name == "" ||
      v.resource_group == ""
    )
  ]
}

resource "null_resource" "validate_nsg_rules" {
  count = length(local.invalid_rules) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Invalid NSG rule rows: ${join(",", local.invalid_rules)}' && exit 1"
  }

  lifecycle {
    ignore_changes = all
  }
}



