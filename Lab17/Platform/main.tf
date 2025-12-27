



/*module "subnet" {
  source = "./Prod/Subnet"
}
*/


module "resource_group" {
  source                      = "./Prod/Resource Group"
  rg_csv_path                 = "${path.root}/Platform/Prod/Resource Group/resource_group.csv"
  default_resource_group_name = "default-rg"
  default_location            = "East US"
}

module "vnet" {
  source        = "./Prod/Vnet"
  vnet_csv_path = "${path.root}/Platform/Prod/Vnet/vnet.csv"
  depends_on    = [module.resource_group]
}


module "subnet" {
  source          = "./Prod/Subnet"
  subnet_csv_path = "${path.root}/Platform/Prod/Subnet/subnet.csv"
  depends_on      = [module.vnet]

}


module "route_table" {
  source      = "./Prod/Route Table"
  rt_csv_path = "${path.root}/Platform/Prod/Route Table/routetable.csv"
  depends_on  = [module.resource_group, module.subnet]
}

module "network_security_group" {
  source       = "./Prod/Nsg"
  nsg_csv_path = "${path.root}/Platform/Prod/Nsg/nsg.csv"
  depends_on   = [module.resource_group, module.subnet]
}









