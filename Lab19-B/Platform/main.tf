



/*module "subnet" {
  source = "./Prod/Subnet"
}
*/


module "vnet" {
  source = "./Prod/Vnet"
  vnet_csv_path = "${path.root}/Platform/Prod/Vnet/vnet.csv"
}


module "subnet" {
  source = "./Prod/Subnet"
  subnet_csv_path = "${path.root}/Platform/Prod/Subnet/subnet.csv"
  depends_on = [ module.vnet ]

}
