locals {
  bu_name     = basename(abspath(path.module))
  region_name = basename(abspath(path.module))
}

data "azurerm_firewall_policy" "fw-ci-hub-policy-01" {
  name                = "fw-ci-hub-policy-01"
  resource_group_name = "fw-ci-hub-rg"
}

module "non-prod" {
  source         = "../../../firewallcore"
  firewall_rules = local.non_prod_firewall_rules

}

module "prod" {
  source         = "../../../firewallcore"
  firewall_rules = local.prod_firewall_rules

}





