
terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "7a0bf087-e2b9-4fb2-bb79-4ef863e0c025"

}

locals {
  subnet_newbits       = 8
  default_subnet_names = ["subnet-01", "subnet-02", "subnet-03"]

  vnets_csv   = csvdecode(file("${path.module}/vnets.csv"))
  subnets_csv = csvdecode(file("${path.module}/subnets.csv"))

  vnets_from_csv = [for r in local.vnets_csv : {
    role                = r.role
    name                = r.name
    address_space       = [r.address_space]
    location            = coalesce(r.location, var.location)
    resource_group_role = r.role
  }]

  vnets_with_name = [for v in local.vnets_from_csv : merge(v, { name = coalesce(v.name, format("vnet-%s-%s-%s", var.region, v.role, "auto")) })]

  subnets_per_vnet = [
    for v in local.vnets_with_name : (
      length([for r in local.subnets_csv : r if r.role == v.role]) > 0 ? [
        for idx, sname in sort([for rr in local.subnets_csv : rr.subnet_name if rr.role == v.role]) : {
          name           = sname
          address_prefix = cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
        ] : [
        for idx, sname in local.default_subnet_names : {
          name           = sname
          address_prefix = cidrsubnet(v.address_space[0], local.subnet_newbits, idx)
        }
      ]
    )
  ]
}

module "env" {
  source           = "./env/Prod/ci"
  vnets_with_name  = local.vnets_with_name
  subnets_per_vnet = local.subnets_per_vnet
}


module "env-dev" {
  source           = "./env/dev/ci"
  vnets_with_name  = local.vnets_with_name
  subnets_per_vnet = local.subnets_per_vnet

}