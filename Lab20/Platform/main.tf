


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

/*
module "Virtual-Machine" {
  source     = "./Prod/Virtual Machine"
  depends_on = [module.Route-Table]

}
*/
