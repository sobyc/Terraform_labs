resource "azurerm_network_security_group" "this" {
  for_each = { for n in var.nsgs : n.name => n }

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule = [for r in each.value.nsg_rules : {
    name                       = r.name
    priority                   = r.priority
    direction                  = r.direction
    access                     = r.access
    protocol                   = r.protocol
    source_port_range          = r.source_port_range
    destination_port_range     = r.destination_port_range
    source_address_prefix      = r.source_address_prefix
    destination_address_prefix = r.destination_address_prefix
  }]
}

