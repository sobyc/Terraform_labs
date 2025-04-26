resource "azurerm_virtual_network" "vnet-main" {
  count               = length(var.vnet_configs)
  name                = var.vnet_configs[count.index].name
  address_space       = var.vnet_configs[count.index].address_space
  location            = var.vnet_configs[count.index].location
  resource_group_name = var.vnet_configs[count.index].resource_group_name
}
