resource "azurerm_resource_group" "rg" {
  name     = var.rg_names[count.index]
  count    = length(var.rg_names)
  location = var.location

  tags = var.tags

}



resource "azurerm_virtual_network" "vnet-main" {
  name                = var.vnet_names[count.index]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[count.index].name
  address_space       = ["${var.address_space[count.index]}"]
  count               = length(var.vnet_names)

  depends_on = [azurerm_resource_group.rg]
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
