resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : "${var.virtual_network_name}-${s.name}" => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [each.value.address_prefix]
}
