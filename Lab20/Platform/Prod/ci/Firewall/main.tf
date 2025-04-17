#Azure Generic Route Table Module

data "azurerm_resource_group" "rg1" {
  name = "rg-ci-prd-hub-01"
}

output "rg1-id" {
  value = data.azurerm_resource_group.rg1.id
}

data "azurerm_virtual_network" "vnet-hub"{
  name = "vnet-ci-prd-hub-01"
  resource_group_name = "rg-ci-prd-hub-01"
}

output "vnet-hub-id" {
  value = data.azurerm_virtual_network.vnet-hub.id
}

data "azurerm_subnet" "hub-firewall-subnet" {
  name = "AzureFirewallSubnet"
  resource_group_name = "rg-ci-prd-hub-01"
  virtual_network_name = "vnet-ci-prd-hub-01"
}

output "snet-hub-id" {
  value = data.azurerm_subnet.hub-firewall-subnet.id
}

resource "azurerm_public_ip" "pip-fw-hub-01" {
  name = "pip-fw-hub-01"
  location = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_firewall" "fw-hub-01" {
  name = "fw-hub-01"
  location = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  ip_configuration {
    name = "config-pip"
    subnet_id = data.azurerm_subnet.hub-firewall-subnet.id
    public_ip_address_id = azurerm_public_ip.pip-fw-hub-01.id
  }
}


resource "azurerm_firewall_network_rule_collection" "rule-collection-01" {
  name                = "rule-collection-01"
  azure_firewall_name = azurerm_firewall.fw-hub-01.name
  resource_group_name = data.azurerm_resource_group.rg1.name
  priority            = 400
  action              = "Allow"

  rule {
    name                    = "Any-Any"
    source_addresses        = ["*"]
    destination_ports       = [ "*" ]
    destination_addresses   = ["*"]
    protocols               = ["TCP","UDP"]
  }
}