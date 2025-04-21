
/* module "resource_group" {
  source = "../Resource Group"
}


module "vnet-hub" {
  source = "../Vnet"

}*/
data "azurerm_virtual_network" "vnet-01" {
  name                = "vnet-ci-prd-hub-01"
  resource_group_name = "rg-ci-prd-hub-01"
}

output "virtual_network_id-01" {
  value = data.azurerm_virtual_network.vnet-01.id
}

data "azurerm_virtual_network" "vnet-02" {
  name                = "vnet-ci-prd-spoke-01"
  resource_group_name = "rg-ci-prd-spoke-01"
}

output "virtual_network_id-02" {
  value = data.azurerm_virtual_network.vnet-02.id
}


data "azurerm_virtual_network" "vnet-03" {
  name                = "vnet-ci-prd-spoke-02"
  resource_group_name = "rg-ci-prd-spoke-02"
}

output "virtual_network_id-03" {
  value = data.azurerm_virtual_network.vnet-03.id
}


resource "azurerm_subnet" "subnet-vnet-01" {
  name                 = var.subnet_names-vnet-hub[count.index]
  virtual_network_name = data.azurerm_virtual_network.vnet-01.name
  resource_group_name  = data.azurerm_virtual_network.vnet-01.resource_group_name
  address_prefixes     = ["${var.subnet_prefixes-vnet-01[count.index]}"]
  count                = length(var.subnet_names-vnet-hub)


}


resource "azurerm_subnet" "subnet-vnet-02" {
  name                 = var.subnet_names-vnet-spoke1[count.index]
  virtual_network_name = data.azurerm_virtual_network.vnet-02.name
  resource_group_name  = data.azurerm_virtual_network.vnet-02.resource_group_name
  address_prefixes     = ["${var.subnet_prefixes-vnet-02[count.index]}"]
  count                = length(var.subnet_names-vnet-spoke1)

}


resource "azurerm_subnet" "subnet-vnet-03" {
  name                 = var.subnet_names-vnet-spoke2[count.index]
  virtual_network_name = data.azurerm_virtual_network.vnet-03.name
  resource_group_name  = data.azurerm_virtual_network.vnet-03.resource_group_name
  address_prefixes     = ["${var.subnet_prefixes-vnet-03[count.index]}"]
  count                = length(var.subnet_names-vnet-spoke2)



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
