resource "azurerm_firewall_policy_rule_collection_group" "fw-policy-rule-collection" {
  count              = length(var.firewall_rules)
  name               = var.firewall_rules[count.index].policy_rule_collection_group_name
  firewall_policy_id = var.firewall_rules[count.index].firewall_policy_id
  priority           = var.firewall_rules[count.index].priority

  dynamic "network_rule_collection" {
    for_each = var.firewall_rules[count.index]["network_rule_collection"]
    content {
      name     = network_rule_collection.value["name"]
      priority = network_rule_collection.value["priority"]
      action   = network_rule_collection.value["action"]
      dynamic "rule" {
        for_each = network_rule_collection.value["rule"]
        content {
          name                  = rule.value["name"]
          protocols             = rule.value["protocols"]
          source_addresses      = rule.value["source_addresses"]
          destination_addresses = lookup(rule.value, "destination_addresses", null) != null ? rule.value["destination_addresses"] : []
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null) != null ? rule.value["destination_fqdns"] : []
          destination_ports     = rule.value["destination_ports"]
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.firewall_rules[count.index]["application_rule_collection"]
    content {
      name     = application_rule_collection.value["name"]
      priority = application_rule_collection.value["priority"]
      action   = application_rule_collection.value["action"]
      dynamic "rule" {
        for_each = application_rule_collection.value["rule"]
        content {
          name                  = rule.value["name"]
          source_addresses      = rule.value["source_addresses"]
          destination_addresses = rule.value["destination_addresses"]
          destination_fqdns     = rule.value["destination_fqdns"]
          dynamic "protocols" {
            for_each = rule.value["protocols"]
            content {
              port = protocols.value["port"]
              type = protocols.value["type"]
            }
          }
        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = var.firewall_rules[count.index]["nat_rule_collection"]
    content {
      name     = nat_rule_collection.value["name"]
      priority = nat_rule_collection.value["priority"]
      action   = nat_rule_collection.value["action"]
      dynamic "rule" {
        for_each = nat_rule_collection.value["rule"]
        content {
          name                = rule.value["name"]
          protocols           = rule.value["protocols"]
          source_addresses    = rule.value["source_addresses"]
          destination_address = rule.value["destination_address"]
          destination_ports   = rule.value["destination_ports"]
          translated_port     = rule.value["translated_port"]
        }
      }
    }
  }
}

