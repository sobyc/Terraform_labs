resource "azurerm_resource_group" "rg-01" {
  name     = "rg-ci-hub-01"
  location = "Central India"

}

resource "azurerm_resource_group" "rg-02" {
  name     = "rg-ci-finance-01"
  location = "Central India"

}

resource "azurerm_resource_group" "rg-03" {
  name     = "rg-ci-hr-01"
  location = "Central India"

}





locals {
  vnets = [
    {
      name                = "vnet-ci-hub-01"
      address_space       = ["10.0.0.0/16"]
      location            = "Central India"
      resource_group_name = azurerm_resource_group.rg-01.name
    },
    {
      name                = "vnet-ci-finance-01"
      address_space       = ["10.1.0.0/16"]
      location            = "Central India"
      resource_group_name = azurerm_resource_group.rg-02.name
    },
    {
      name                = "vnet-ci-hr-01"
      address_space       = ["10.2.0.0/16"]
      location            = "Central India"
      resource_group_name = azurerm_resource_group.rg-03.name
    }
  ]
}

module "vnet" {
  source       = "../../../modules/networking/vnet"
  vnet_configs = local.vnets
  depends_on   = [azurerm_resource_group.rg-01, azurerm_resource_group.rg-02, azurerm_resource_group.rg-03]
}

module "subnet" {
  count                = length(local.vnets)
  source               = "../../../modules/networking/subnet"
  subnet_count         = 3
  subnet_prefix        = "${local.vnets[count.index].name}-subnet"
  vnet_cidr            = local.vnets[count.index].address_space[0]
  virtual_network_name = local.vnets[count.index].name
  resource_group_name  = local.vnets[count.index].resource_group_name
  depends_on           = [azurerm_resource_group.rg-01, azurerm_resource_group.rg-02, azurerm_resource_group.rg-03, module.vnet]
}
