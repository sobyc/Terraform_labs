




resource "azurerm_subnet" "subnet-vnet-01" {
  name                 = var.subnet_names-vnet-hub[count.index]
  virtual_network_name = "vnet-eus-prd-hub-01"
  resource_group_name  = "rg-eus-prd-hub-01"
  address_prefixes     = ["${var.subnet_prefixes-vnet-01[count.index]}"]
  count                = length(var.subnet_names-vnet-hub)


}


resource "azurerm_subnet" "subnet-vnet-02" {
  name                 = var.subnet_names-vnet-spoke1[count.index]
  virtual_network_name = "vnet-eus-prd-spoke-01"
  resource_group_name  = "rg-eus-prd-spoke-01"
  address_prefixes     = ["${var.subnet_prefixes-vnet-02[count.index]}"]
  count                = length(var.subnet_names-vnet-spoke1)


}


resource "azurerm_subnet" "subnet-vnet-03" {
  name                 = var.subnet_names-vnet-spoke2[count.index]
  virtual_network_name = "vnet-eus-prd-spoke-02"
  resource_group_name  = "rg-eus-prd-spoke-02"
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
