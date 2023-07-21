// Authenticate using service principal, create provider file and use variable to use secret
// Create Resource group
// Create Storage Account



module "resource_group" {
  source    = "./Modules/Resource Group"
  rgname-02 = "rg-01"
  location  = "West India"
}

module "storage_account" {
  source              = "./Modules/Storage Account"
  sa_name             = "sawihub"
  sa_location         = "West India"
  resource_group_name = module.resource_group.output-resource_group
}
