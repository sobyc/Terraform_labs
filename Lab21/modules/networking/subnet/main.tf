/*resource "azurerm_subnet" "subnet-hub" {
  name                 = var.subnet_names_vnet_hub[count.index]
  virtual_network_name = azurerm_virtual_network.vnet-main[count.index].name
  resource_group_name  = azurerm_resource_group.rg-hub.name
  address_prefixes     = ["${var.subnet_address_prefixes[count.index]}"]
  count                = length(var.subnet_names_vnet_hub)



}*/


resource "azurerm_subnet" "subnet-hub" {
  name                 = var.subnet_names_vnet_hub
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
  resource_group_name  = var.resource_group_name
}
