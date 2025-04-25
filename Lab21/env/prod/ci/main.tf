
module "vnet" {
  source = "../../../modules/networking/vnet"
}

module "subnet" {
  source                = "../../../modules/networking/subnet"
  subnet_names_vnet_hub = var.subnet_names_vnet_hub
  address_prefixes      = var.subnet_address_prefixes
  vnet_name             = module.vnet.vnet_names[0]
  resource_group_name   = module.vnet.vnet_names[0].resource_group_name.name # Change this to your desired resource group name

  depends_on = [module.vnet] # Ensure the VNet is created before the subnet

}





/*


resource "azurerm_resource_group" "rg-ci-hub-core-01" {
  name     = "rg-ci-hub-core-01"
  location = "Central India" # Change this to your desired location
  tags = {
    environment = "prod"
    owner       = "Sourabh Chhabra " # Change this to your name or the name of the owner
    project     = "Lab21"
  }

}


*/
