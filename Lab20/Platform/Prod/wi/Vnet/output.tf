output "vnet-hub" {
  value = azurerm_virtual_network.vnet-01.name
}

output "vnet-spoke-1" {
  value = azurerm_virtual_network.vnet-02.name
}


output "vnet-spoke-2" {
  value = azurerm_virtual_network.vnet-03.name
}


output "rg-01" {
  value = module.resource_group.rg-01

}



output "rg-02" {
  value = module.resource_group.rg-02
}



output "rg-03" {
  value = module.resource_group.rg-03
}
