locals {
  prod_firewall_rules = [{
    policy_rule_collection_group_name = "${(var.bu_name)}-${(local.region_name)}-prod-rule-collection-group"
    priority                          = 1000
    firewall_policy_id                = data.azurerm_firewall_policy.fw-ci-hub-policy-01.id

    network_rule_collection = [{
      name     = "default-rule-collection"
      priority = 1100
      action   = "Allow"
      rule = [{
        name                  = "any-any-rule-01"
        protocols             = ["TCP", "ICMP"]
        source_addresses      = ["10.0.0.0/8"]
        destination_addresses = ["10.0.0.0/8"]
        destination_ports     = ["*"]

      }]
    }]

    application_rule_collection = []
    nat_rule_collection         = []
  }]
}
