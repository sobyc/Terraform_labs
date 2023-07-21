output "vnet-hub" {
  value = azurerm_virtual_network.vnet-01.name
}

output "vnet-spoke" {
  value = azurerm_virtual_network.vnet-02.name
}
