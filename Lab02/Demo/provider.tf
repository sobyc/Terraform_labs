terraform {
  required_providers {
    azurerm = {
      
        }
  }
}
provider "azurerm" {
  features {}
  
  client_id = "cfdcc86f-d910-4b45-aa9c-cbbf3ac30cdd"
  client_secret = var.client_secret
  tenant_id = "eb24ae38-85f4-4e3d-b0da-d84b672ea229"
  subscription_id = "87c9cfc8-757b-45a9-8e3a-b879cb53f459"
}