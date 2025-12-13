# Subnet Module

This module creates subnets using an explicit list of subnets. It uses `for_each` to create subnet resources and keys them by `<vnetName>-<subnetName>` to ensure stable, unique names across VNETs.

Usage:

- Provide `virtual_network_name` and `resource_group_name`.
- Provide `subnets` as a list of objects with `name` and `address_prefix` (e.g. `10.0.1.0/24`).
 - The module uses the provided `subnet.name` verbatim for the Azure subnet `name` attribute, so if you don't want a VNet prefix in the Azure subnet name, pass simple names like `subnet-01` or `GatewaySubnet`.
 - The `for_each` key is prefixed with `virtual_network_name`, which ensures keys are unique across VNets while `subnet.name` is unchanged.

Example consumer:

```
module "subnet" {
  count = length(local.vnets)
  source = "../../../modules/networking/subnet"
  subnets = local.subnets_per_vnet[count.index]
  virtual_network_name = local.vnets[count.index].name
  resource_group_name  = local.vnets[count.index].resource_group_name
}
```

Scaling:

- To add more subnets, append to `default_subnet_names` or add to the per-vnet `subnets` list.
- Using `for_each` ensures subnet naming is stable and additions/removals won't reindex resources.

Notes:

- You can compute `address_prefix` using `cidrsubnet()` in the parent module to avoid conflicts and maintain an address plan.
