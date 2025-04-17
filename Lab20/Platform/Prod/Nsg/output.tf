output "network_security_group_id" {
  description = "Network security group ID"
  value       = azurerm_network_security_group.nsg-hub-identity.id
}
