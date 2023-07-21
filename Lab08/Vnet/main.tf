#Azure Generic vNet Module

module "resource_group" {
  source = "../Resource Group"
}

resource "azurerm_virtual_network" "vnet-01" {
  name                = "vnet-${var.env}-${var.vnet-hub}-01"
  location            = var.location
  address_space       = ["${var.address_space-vnet-01}"]
  resource_group_name = module.resource_group.rg-01
  dns_servers         = var.dns_servers
  tags                = var.tags

  depends_on = [
    module.resource_group
  ]
}

/*
resource "azurerm_subnet" "subnet-vnet-01" {
  name                 = var.subnet_names-vnet-01[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  resource_group_name  = module.resource_group.rg-01
  address_prefixes     = ["${var.subnet_prefixes-vnet-01[count.index]}"]
  count                = length(var.subnet_names-vnet-01)

  depends_on = [
    azurerm_virtual_network.vnet-01
  ]
}
*/


resource "azurerm_virtual_network" "vnet-02" {
  name                = "vnet-${var.env}-${var.vnet-spoke}-01"
  location            = var.location
  address_space       = ["${var.address_space-vnet-02}"]
  resource_group_name = module.resource_group.rg-02
  dns_servers         = var.dns_servers
  tags                = var.tags

  depends_on = [
    module.resource_group
  ]
}


/*
resource "azurerm_subnet" "subnet-vnet-02" {
  name                 = var.subnet_names-vnet-02[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-02.name
  resource_group_name  = module.resource_group.rg-02
  address_prefixes     = ["${var.subnet_prefixes-vnet-02[count.index]}"]
  count                = length(var.subnet_names-vnet-02)

  depends_on = [
    azurerm_virtual_network.vnet-02
  ]
}
*/
