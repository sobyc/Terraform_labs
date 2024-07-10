output "vnet-hub" {
  value = azurerm_virtual_network.vnet-01.name
}

output "vnet-spoke-1" {
  value = azurerm_virtual_network.vnet-02.name
}


output "vnet-spoke-2" {
  value = azurerm_virtual_network.vnet-03.name
}
