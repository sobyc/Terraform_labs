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
      address_space       = ["10.10.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-01.name
      resource_group_role = "hub"
    },
    {
      role                = "finance"
      name                = ""
      address_space       = ["10.11.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-02.name
    },
    {
      role                = "hr"
      name                = ""
      address_space       = ["10.12.0.0/16"]
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
}

module "vnet" {
  source       = "../../../modules/networking/vnet"
  vnet_configs = local.vnets_with_name
}

module "subnet" {
  count                = length(local.vnets_with_name)
  source               = "../../../modules/networking/subnet"
  subnets              = local.subnets_per_vnet[count.index]
  virtual_network_name = local.vnets_with_name[count.index].name
  resource_group_name  = local.vnets_with_name[count.index].resource_group_name
  depends_on           = [module.vnet]
}

locals {
  nsgs_per_vnet = [
    for vindex, vnet in local.vnets_with_name : (
      vnet.role == "hub" ? [
        {
          name                 = "ManagementNSG"
          nsg_rules            = []
          associate_subnet_ids = compact([try(module.subnet[vindex].subnet_ids["${vnet.name}-ManagementSubnet"], null)])
        }
        ] : [
        {
          name                 = format("%s-nsg", vnet.name)
          nsg_rules            = []
          associate_subnet_ids = [for k, id in module.subnet[vindex].subnet_ids : id]
        }
      ]
    )
  ]
}

module "nsg" {
  count               = length(local.vnets_with_name)
  source              = "../../../modules/networking/nsg"
  nsgs                = local.nsgs_per_vnet[count.index]
  resource_group_name = local.vnets_with_name[count.index].resource_group_name
  location            = var.location
  tags                = {}
  depends_on          = [module.subnet]
}

locals {
  nsg_assoc_list = flatten([
    for vindex, vnet in local.vnets_with_name : (
      vnet.role == "hub" ? [
        {
          key       = "${vnet.name}-ManagementNSG-${vnet.name}-ManagementSubnet"
          nsg_id    = module.nsg[vindex].nsg_ids["ManagementNSG"]
          subnet_id = module.subnet[vindex].subnet_ids["${vnet.name}-ManagementSubnet"]
        }
        ] : [
        for k, id in module.subnet[vindex].subnet_ids : {
          key       = "${vnet.name}-${k}"
          nsg_id    = module.nsg[vindex].nsg_ids[format("%s-nsg", vnet.name)]
          subnet_id = id
        }
      ]
    )
  ])

  nsg_associations = { for item in local.nsg_assoc_list : item.key => { nsg_id = item.nsg_id, subnet_id = item.subnet_id } }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = local.nsg_associations

  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.nsg_id
}
