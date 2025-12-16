resource "azurerm_resource_group" "rg-01" {
  name     = format("rg-%s-%s-%s-01", var.region, local.env_abbr, "hub")
  location = var.location

}

resource "azurerm_resource_group" "rg-02" {
  name     = format("rg-%s-%s-%s-01", var.region, local.env_abbr, "finance")
  location = var.location

}

resource "azurerm_resource_group" "rg-03" {
  name     = format("rg-%s-%s-%s-01", var.region, local.env_abbr, "hr")
  location = var.location

}





locals {
  environment          = var.environment
  default_env_abbr_map = { prod = "pr", dev = "dev", staging = "stg", ci = "ci" }
  env_abbr             = lookup(var.env_abbr_map, var.environment, lookup(local.default_env_abbr_map, var.environment, var.environment))

  default_vnets = [
    {
      role                = "hub"
      name                = ""
      address_space       = ["10.0.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-01.name
      resource_group_role = "hub"
    },
    {
      role                = "finance"
      name                = ""
      address_space       = ["10.1.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-02.name
    },
    {
      role                = "hr"
      name                = ""
      address_space       = ["10.2.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-03.name
    }
  ]

  base_vnets = length(var.vnets_with_name) > 0 ? var.vnets_with_name : tolist(local.default_vnets)

  vnets_with_name = [
    for v in local.base_vnets : merge(v, {
      name = coalesce(lookup(v, "name", null), format("vnet-%s-%s-%s", local.env_abbr, var.region, lookup(v, "role", "unknown"))),
      resource_group_name = coalesce(lookup(v, "resource_group_name", null), format("rg-%s-%s-%s-01", var.region, local.env_abbr, lookup(v, "resource_group_role", lookup(v, "role", "unknown"))))
    })
  ]

  default_subnet_names = ["subnet-01", "subnet-02", "subnet-03"]
  subnet_newbits       = 8
  custom_subnet_names = {
    "hub" = ["GatewaySubnet", "FirewallSubnet", "ManagementSubnet"]
  }

  subnets_per_vnet = length(var.subnets_per_vnet) > 0 ? var.subnets_per_vnet : [
    for vnet in local.vnets_with_name : [
      for idx, sname in lookup(local.custom_subnet_names, vnet.role, local.default_subnet_names) : {
        name           = sname
        address_prefix = cidrsubnet(vnet.address_space[0], local.subnet_newbits, idx)
      }
    ]
  ]

  # Helper maps keyed by vnet name for stable for_each usage (prevents index shifting)
  vnets_map = { for v in local.vnets_with_name : v.name => v }
  vnet_index_map = { for idx, v in local.vnets_with_name : v.name => idx }
  subnets_per_vnet_map = { for idx, v in local.vnets_with_name : v.name => local.subnets_per_vnet[idx] }
}

module "vnet" {
  source       = "../../../modules/networking/vnet"
  vnet_configs = local.vnets_with_name
  depends_on   = [azurerm_resource_group.rg-01, azurerm_resource_group.rg-02, azurerm_resource_group.rg-03]
}

module "subnet" {
  for_each             = local.vnets_map
  source               = "../../../modules/networking/subnet"
  subnets              = local.subnets_per_vnet_map[each.key]
  virtual_network_name = each.key
  resource_group_name  = each.value.resource_group_name
  depends_on           = [azurerm_resource_group.rg-01, azurerm_resource_group.rg-02, azurerm_resource_group.rg-03, module.vnet]
} 

locals {
  nsgs_per_vnet = [
    for vnet in local.vnets_with_name : (
      vnet.role == "hub" ? [
        {
          name                 = "ManagementNSG"
          nsg_rules            = []
          associate_subnet_ids = compact([try(module.subnet[vnet.name].subnet_ids["${vnet.name}-ManagementSubnet"], null)])
        }
        ] : [
        {
          name                 = format("%s-nsg", vnet.name)
          nsg_rules            = []
          associate_subnet_ids = [for k, id in module.subnet[vnet.name].subnet_ids : id]
        }
      ]
    )
  ]
}

module "nsg" {
  for_each            = local.vnets_map
  source              = "../../../modules/networking/nsg"
  nsgs                = local.nsgs_per_vnet[lookup(local.vnet_index_map, each.key, 0)]
  resource_group_name = each.value.resource_group_name
  location            = var.location
  tags                = {}
  depends_on          = [module.subnet]
}

locals {
  nsg_assoc_list = flatten([
    for vnet in local.vnets_with_name : (
      vnet.role == "hub" ? [
        {
          key       = "${vnet.name}-ManagementNSG-${vnet.name}-ManagementSubnet"
          nsg_id    = module.nsg[vnet.name].nsg_ids["ManagementNSG"]
          subnet_id = module.subnet[vnet.name].subnet_ids["${vnet.name}-ManagementSubnet"]
        }
        ] : [
        for k, id in module.subnet[vnet.name].subnet_ids : {
          key       = "${vnet.name}-${k}"
          nsg_id    = module.nsg[vnet.name].nsg_ids[format("%s-nsg", vnet.name)]
          subnet_id = id
        }
      ]
    )
  ])

  # Remove duplicate identical association entries and build associations map
  nsg_key_list     = [for item in local.nsg_assoc_list : item.key]
  nsg_keys_unique  = distinct(local.nsg_key_list)

  nsg_associations = { for k in local.nsg_keys_unique : k => { nsg_id = local.nsg_assoc_list[index(local.nsg_key_list, k)].nsg_id, subnet_id = local.nsg_assoc_list[index(local.nsg_key_list, k)].subnet_id } }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = local.nsg_associations

  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.nsg_id

  depends_on = [module.subnet]
}
