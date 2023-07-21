terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}

  client_id       = "cfdcc86f-d910-4b45-aa9c-cbbf3ac30cdd"
  client_secret   = "jTU8Q~UnSZr5~rPYnAaH7Oir_4TIgk6RUFl63ag_"
  tenant_id       = "eb24ae38-85f4-4e3d-b0da-d84b672ea229"
  subscription_id = "87c9cfc8-757b-45a9-8e3a-b879cb53f459"

}




resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "West Europe"
}



resource "azurerm_storage_account" "sa-01" {
  name                     = "sa00101010101"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"


  network_rules {
    default_action             = "Deny"
  }
}
