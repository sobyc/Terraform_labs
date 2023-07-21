
// Authenticate using service principal, create provider file and use variable to use secret
// Create Resource group
// Create virtual network, dclaring subnet inside the vnet code along with Tags


resource "azurerm_resource_group" "rg-02" {
  name     = var.rgname-02
  location = var.location
}

resource "azurerm_virtual_network" "vnet-01" {
  name                = var.vnet-01
  location            = azurerm_resource_group.rg-02.location
  resource_group_name = azurerm_resource_group.rg-02.name
  address_space       = ["12.0.0.0/16"]
  dns_servers         = ["12.0.0.4", "12.0.0.5"]
  count               = 2
  subnet {
    name           = "snet-del-hub-platform-01"
    address_prefix = "12.0.1.0/24"
  }

  subnet {
    name           = "snet-del-hub-management-01"
    address_prefix = "12.0.2.0/24"

  }

  tags = {
    environment = "Non-Prod"
  }
}

output "rg-name" {
  value = azurerm_resource_group.rg-02.id
}
