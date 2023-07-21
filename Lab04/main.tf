// Authenticate using service principal, create provider file and use variable to use secret
// Create Resource group
// Create virtual network, declaring subnet inside the vnet code along with Tags





resource "azurerm_resource_group" "rg-01" {
  name     = "rg-ci-hub-01"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet-ci-hub-01" {
  name                = "vnet-ci-hub-01"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  tags = {
    environment = "Production"
  }
}
