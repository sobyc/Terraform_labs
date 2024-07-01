
module "resource_group" {
  source = "../Resource Group"
}


module "vnet-hub" {
  source = "../Vnet"

}



resource "azurerm_subnet" "subnet-vnet-01" {
  name                 = var.subnet_names-vnet-hub[count.index]
  virtual_network_name = module.vnet-hub.vnet-hub
  resource_group_name  = module.resource_group.rg-01
  address_prefixes     = ["${var.subnet_prefixes-vnet-01[count.index]}"]
  count                = length(var.subnet_names-vnet-hub)

  depends_on = [
    module.resource_group,module.vnet-hub
  ]
}


resource "azurerm_subnet" "subnet-vnet-02" {
  name                 = var.subnet_names-vnet-spoke1[count.index]
  virtual_network_name = module.vnet-hub.vnet-spoke-1
  resource_group_name  = module.resource_group.rg-02
  address_prefixes     = ["${var.subnet_prefixes-vnet-02[count.index]}"]
  count                = length(var.subnet_names-vnet-spoke1)

  depends_on = [
    module.resource_group,module.vnet-hub
  ]
}


resource "azurerm_subnet" "subnet-vnet-03" {
  name                 = var.subnet_names-vnet-spoke2[count.index]
  virtual_network_name = module.vnet-hub.vnet-spoke-2
  resource_group_name  = module.resource_group.rg-03
  address_prefixes     = ["${var.subnet_prefixes-vnet-03[count.index]}"]
  count                = length(var.subnet_names-vnet-spoke2)
  
  depends_on = [
    module.resource_group,module.vnet-hub
  ]

}




/*
module "Nsg" {
  source = "../Nsg"
}

module "VNG" {
  source     = "../VNG"
  depends_on = [azurerm_subnet.subnet-vnet-01]
}
*/
