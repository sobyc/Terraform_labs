terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  
}



module "vnet" {
  source = "./Prod/Vnet"
}



module "Subnet" {
  source     = "./Prod/Subnet"
  depends_on = [module.vnet]
}


module "Nsg" {
  source     = "./Prod/Nsg"
  depends_on = [module.vnet, module.Subnet]
}


module "Route-Table" {
  source     = "./Prod/Route Table"
  depends_on = [module.Nsg]

}



module "Virtual-Machine" {
  source     = "./Prod/Virtual Machine"
  depends_on = [module.Route-Table, module.availibilityset, module.Nsg, module.Subnet, module.vnet]

}



module "Load-Balancer" {
  source     = "./Prod/loadbalancer"
  depends_on = [module.vnet, module.Subnet, module.Nsg, module.Route-Table]

}

module "availibilityset" {
  source     = "./Prod/availabilityset"
  depends_on = [module.vnet, module.Subnet, module.Nsg, module.Route-Table, module.Load-Balancer]

}



