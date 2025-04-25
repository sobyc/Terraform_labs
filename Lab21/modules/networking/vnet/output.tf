output "vnet_name" {
  value = [for v in azurerm_virtual_network.vnet-main : v.name]
}


output "rg" {
  value = [for v in azurerm_resource_group.rg : v.name]
}
