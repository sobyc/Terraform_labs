locals {
  vnet_peering_data = csvdecode(file("${path.root}/Platform/Prod/Vnet/vnetpeer/vnetpeer.csv"))
}

# Create VNet Peering Resources
resource "azurerm_virtual_network_peering" "vnet_peering" {
  for_each = { for idx, peering in local.vnet_peering_data : "${peering.vnet_id}-${peering.peer_vnet_id}" => peering }

  # Name from the CSV
  name                        = each.value.vnet_peering_name
  resource_group_name          = each.value.resource_group      # Local VNet's resource group
  virtual_network_name         = each.value.vnet_name  # Extract VNet name from the full ID

  # Full VNet ID for the remote VNet
  remote_virtual_network_id    = each.value.peer_vnet_id  # This is the full ID of the remote VNet

  # Remote VNet's resource group
  #remote_resource_group_name   = each.value.peer_resource_group  # Remote resource group

  # Allow various features based on the CSV
  allow_virtual_network_access = each.value.allow_virtual_network_access == "true" ? true : false
  allow_forwarded_traffic     = each.value.allow_forwarded_traffic == "true" ? true : false
  allow_gateway_transit       = each.value.allow_gateway_transit == "true" ? true : false
  use_remote_gateways         = each.value.use_remote_gateways == "true" ? true : false
}