output "nsg_ids" {
  description = "Map of created NSG ids keyed by NSG name"
  value       = { for k, n in azurerm_network_security_group.this : k => n.id }
}

output "nsg_names" {
  description = "Map of created NSG names keyed by NSG name"
  value       = { for k, n in azurerm_network_security_group.this : k => n.name }
}

