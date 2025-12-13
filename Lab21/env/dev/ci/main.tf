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

  vnets = [
    {
      role                = "hub"
      address_space       = ["10.10.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-01.name
    },
    {
      role                = "finance"
      address_space       = ["10.11.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-02.name
    },
    {
      role                = "hr"
      address_space       = ["10.12.0.0/16"]
      location            = var.location
      resource_group_name = azurerm_resource_group.rg-03.name
    }
  ]

  default_subnet_names = ["subnet-01", "subnet-02", "subnet-03"]
  subnet_newbits       = 8
  custom_subnet_names = {
    "hub" = ["GatewaySubnet", "FirewallSubnet", "ManagementSubnet"]
  }

  vnets_with_name = [
    for v in local.vnets : merge(v, {
      name = format("vnet-%s-%s-%s", local.env_abbr, var.region, v.role)
    })
  ]

  subnets_per_vnet = [
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
