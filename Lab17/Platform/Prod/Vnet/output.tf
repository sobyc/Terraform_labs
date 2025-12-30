
output "vnet_ids" {
  description = "Map of VNet name to VNet resource ID."
  value       = { for k, v in azurerm_virtual_network.this : k => v.id }
}

output "vnet_names" {
  description = "Map of VNet name to VNet name."
  value       = { for k, v in azurerm_virtual_network.this : k => v.name }
}

output "vnet_rg" {
  description = "Map of VNet name to resource group."
  value       = { for k, v in azurerm_virtual_network.this : k => v.resource_group_name }
}

output "vnet_locations" {
  description = "Map of VNet name to location."
  value       = { for k, v in azurerm_virtual_network.this : k => v.location }
}
