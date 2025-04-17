


module "ci-subnet" {
  source = "../Prod/ci/Subnet"
}

module "ci-nsg" {
  source     = "../Prod/ci/NSG"
  depends_on = [module.ci-subnet]
}

module "ci-route-table" {
  source     = "../Prod/ci/Route Table"
  depends_on = [module.ci-nsg]
}


module "wi-subnet" {
  source     = "../Prod/wi/Subnet"
  depends_on = [module.ci-route-table]
}

module "wi-nsg" {
  source     = "../Prod/wi/NSG"
  depends_on = [module.wi-subnet]
}

module "wi-route-table" {
  source     = "../Prod/wi/Route Table"
  depends_on = [module.wi-nsg]
}
