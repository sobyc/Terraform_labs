
module "resource_group" {
  source = "../Resource Group"
}


module "vnet-hub" {
  source = "../Vnet"
}



resource "azurerm_subnet" "subnet-vnet-01" {
  name                 = var.subnet_names-vnet-01[count.index]
  virtual_network_name = module.vnet-hub.vnet-hub
  resource_group_name  = module.resource_group.rg-01
  address_prefixes     = ["${var.subnet_prefixes-vnet-01[count.index]}"]
  count                = length(var.subnet_names-vnet-01)


}


resource "azurerm_subnet" "subnet-vnet-02" {
  name                 = var.subnet_names-vnet-02[count.index]
  virtual_network_name = module.vnet-hub.vnet-spoke
  resource_group_name  = module.resource_group.rg-02
  address_prefixes     = ["${var.subnet_prefixes-vnet-02[count.index]}"]
  count                = length(var.subnet_names-vnet-02)


}
