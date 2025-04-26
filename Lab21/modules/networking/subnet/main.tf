resource "azurerm_subnet" "this" {
  count                = var.subnet_count
  name                 = "${var.subnet_prefix}-${count.index + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, count.index)]
}
