
data "azurerm_resource_group" "rg-erpnext" {
  name = var.rg-01
  }

output "rg-erpnext" {
  value = data.azurerm_resource_group.rg-erpnext.id
}

data "azurerm_virtual_machine" "vm-erpnext" {
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
  name = "vncierpnpl01"  
}

output "vm-erpnext" {
  value = data.azurerm_virtual_machine.vm-erpnext.name
}


data "azurerm_virtual_network" "vnet-erpnext" {
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
  name = "vnet-ci-p-odoo-01"  
}

output "vnet-erpnext" {
  value = data.azurerm_virtual_network.vnet-erpnext.name
}

data "azurerm_subnet" "snet-erpnext" {
  name                 = "snet-ci-p-appgateway-01"
  virtual_network_name = data.azurerm_virtual_network.vnet-erpnext.name
  resource_group_name  = data.azurerm_resource_group.rg-erpnext.name
}

output "subnet_id" {
  value = data.azurerm_subnet.snet-erpnext.id
}

data "azurerm_public_ip" "pip-erpnext" {
  name                = "erpnext-gw-pip"
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
}

output "domain_name_label" {
  value = data.azurerm_public_ip.pip-erpnext.domain_name_label
}

output "public_ip_address" {
  value = data.azurerm_public_ip.pip-erpnext.id
}

data "azurerm_web_application_firewall_policy" "waf-erpnext" {
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
  name                = "waf-ci-erpn-p-01"
}

output "id" {
  value = data.azurerm_web_application_firewall_policy.waf-erpnext.id
}

data "azurerm_log_analytics_workspace" "law-erpnext" {
  name                = "law-ci-erpn-p-01"
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
}

output "log_analytics_workspace_id" {
  value = data.azurerm_log_analytics_workspace.law-erpnext.workspace_id
}

locals {
  backend_address_pool_name      = "${data.azurerm_virtual_network.vnet-erpnext.name}-beap"
  frontend_port_name             = "${data.azurerm_virtual_network.vnet-erpnext.name}-feport"
  frontend_ip_configuration_name = "${data.azurerm_virtual_network.vnet-erpnext.name}-feip"
  http_setting_name              = "${data.azurerm_virtual_network.vnet-erpnext.name}-be-htst"
  listener_name                  = "${data.azurerm_virtual_network.vnet-erpnext.name}-httplstn"
  request_routing_rule_name      = "${data.azurerm_virtual_network.vnet-erpnext.name}-rqrt"
  # redirect_configuration_name    = "${data.azurerm_virtual_network.vnet-erpnext.name}-rdrcfg"
}


resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-expnext"
  resource_group_name = data.azurerm_resource_group.rg-erpnext.name
  location            = data.azurerm_resource_group.rg-erpnext.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
    
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = data.azurerm_subnet.snet-erpnext.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = data.azurerm_public_ip.pip-erpnext.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [ "10.0.0.6", ]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
  /*waf_configuration {
    firewall_mode            = "Detection"
    rule_set_version         = "3.2"
    enabled = "true"
    
  }*/
  firewall_policy_id = data.azurerm_web_application_firewall_policy.waf-erpnext.id
}
