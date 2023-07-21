#Azure Generic vNet Module

module "resource_group" {
  source = "../Resource Group"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet-name}-01"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = module.resource_group.rg-name
  dns_servers         = "${var.dns_servers}"
  tags                = "${var.tags}"

  depends_on = [
    module.resource_group
  ]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = module.resource_group.rg-name
  address_prefixes     = ["${var.subnet_prefixes[count.index]}"]
  count                = "${length(var.subnet_names)}"

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}