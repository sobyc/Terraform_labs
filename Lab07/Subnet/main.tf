/*
resource "azurerm_virtual_network" "vnet-01" {
  name                = "vnet-${var.vnet-name}"
  location            = module.azurerm_resource_group.output.rg-02.location
  resource_group_name = module.azurerm_resource_group.output.rg-02.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }
}

*/