
terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
}

module "env" {
  source = "./env/Prod/ci"

}


module "env-dev" {
  source = "./env/dev/ci"

}