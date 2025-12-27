#Azure Generic vNet Module

module "resource_group" {
  source = "../Resource Group"
}

resource "azurerm_virtual_network" "vnet-01" {
  name                = "vnet-${var.region}-${var.env}-${var.vnet-hub}-01"
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
  name                = "vnet-${var.region}-${var.env}-${var.vnet-spoke}-01"
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
resource "azurerm_virtual_network" "vnet-03" {
  name                = "vnet-${var.region}-${var.env}-${var.vnet-spoke}-02"
  location            = var.location
  address_space       = ["${var.address_space-vnet-03}"]
  resource_group_name = module.resource_group.rg-03
  dns_servers         = var.dns_servers
  tags                = var.tags

  depends_on = [
    module.resource_group
  ]
}


resource "azurerm_virtual_network_peering" "hub-spoke1" {
  name = "hub-spoke1"
  resource_group_name = module.resource_group.rg-01
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-02.id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true

  depends_on = [ azurerm_virtual_network.vnet-01,azurerm_virtual_network.vnet-02,azurerm_virtual_network.vnet-03 ]
}



resource "azurerm_virtual_network_peering" "hub-spoke2" {
  name = "hub-spoke2"
  resource_group_name = module.resource_group.rg-01
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-03.id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true

  depends_on = [ azurerm_virtual_network.vnet-01,azurerm_virtual_network.vnet-02,azurerm_virtual_network.vnet-03 ]
}


resource "azurerm_virtual_network_peering" "spoke1-hub" {
  name = "spoke1-hub"
  resource_group_name = module.resource_group.rg-02
  virtual_network_name = azurerm_virtual_network.vnet-02.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-01.id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true

  depends_on = [ azurerm_virtual_network.vnet-01,azurerm_virtual_network.vnet-02,azurerm_virtual_network.vnet-03 ]
}



resource "azurerm_virtual_network_peering" "spoke2-hub" {
  name = "spoke2-hub"
  resource_group_name = module.resource_group.rg-03
  virtual_network_name = azurerm_virtual_network.vnet-03.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-01.id
  allow_forwarded_traffic = true
  allow_virtual_network_access = true

  depends_on = [ azurerm_virtual_network.vnet-01,azurerm_virtual_network.vnet-02,azurerm_virtual_network.vnet-03 ]
}

