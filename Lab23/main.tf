
terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

}


module "Platform" {
  source = "./Platform"
}



