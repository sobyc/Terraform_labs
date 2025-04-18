


module "subnet" {
  source = "./Prod/Subnet"
}

module "Nsg" {
  source     = "./Prod/Nsg"
  depends_on = [module.subnet]
}


module "Route-Table" {
  source     = "./Prod/Route Table"
  depends_on = [module.Nsg]

}
