



/*module "subnet" {
  source = "./Prod/Subnet"
}
*/


module "vnet" {
  source = "./Vnet"

  vnet_csv_path               = "${path.root}/Platform/vnet.csv"
  default_resource_group_name = "rg-network-default" # used if row.resource_group is empty
  default_location            = "centralindia"       # used if row.location is empty

  common_tags = {
    owner = "support"
    env   = "shared"
  }
}


module "subnet" {
  source = "./Subnet"
  depends_on = [ module.vnet ]

}
