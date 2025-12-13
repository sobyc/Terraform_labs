output "subnet_ids" {
  description = "Map of created subnet ids keyed by '<vnet>-<subnet-name>'."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_names" {
  description = "Map of created subnet names keyed by '<vnet>-<subnet-name>'."
  value       = { for k, s in azurerm_subnet.this : k => s.name }
}

output "subnets" {
  description = "List of created subnets with their names and prefixes."
  value       = [for k, s in azurerm_subnet.this : { key = k, id = s.id, name = s.name, prefixes = s.address_prefixes }]
}
