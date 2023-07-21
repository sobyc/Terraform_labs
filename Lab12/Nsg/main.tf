#Azure Generic NSG Module

module "resource_group" {
  source = "../Resource Group"
}

resource "azurerm_network_security_group" "nsg-hub-identity" {
  name                = "rg-${var.env}-${var.vnet-hub}-identity-01"
  location            = var.location
  resource_group_name = module.resource_group.rg-01

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}


resource "azurerm_network_security_group" "nsg-hub-mgmt" {
  name                = "rg-${var.env}-${var.vnet-hub}-mgmt-01"
  location            = var.location
  resource_group_name = module.resource_group.rg-01

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}


resource "azurerm_network_security_group" "nsg-spoke1-web" {
  name                = "rg-${var.env}-${var.vnet-spoke1}-web-01"
  location            = var.location
  resource_group_name = module.resource_group.rg-02

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

resource "azurerm_network_security_group" "nsg-spoke1-app" {
  name                = "rg-${var.env}-${var.vnet-spoke1}-app-01"
  location            = var.location
  resource_group_name = module.resource_group.rg-02

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}


resource "azurerm_network_security_group" "nsg-spoke1-db" {
  name                = "rg-${var.env}-${var.vnet-spoke1}-db-01"
  location            = var.location
  resource_group_name = module.resource_group.rg-02

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

