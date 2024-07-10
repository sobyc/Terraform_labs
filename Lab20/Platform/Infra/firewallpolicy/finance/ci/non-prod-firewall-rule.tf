locals {
  non_prod_firewall_rules = [{
    policy_rule_collection_group_name = "${(var.bu_name)}-${(local.region_name)}-nonprod-rule-collection-group"
    priority                          = 1200
    firewall_policy_id                = data.azurerm_firewall_policy.fw-ci-hub-policy-01.id

    network_rule_collection     = []
    application_rule_collection = []
    nat_rule_collection         = []
  }]
}
