// Authenticate using service principal
// Create Resource group
// Use existing Keyvault


terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}

  client_id       = "cfdcc86f-d910-4b45-aa9c-cbbf3ac30cdd"
  client_secret   = var.client_secret
  tenant_id       = "eb24ae38-85f4-4e3d-b0da-d84b672ea229"
  subscription_id = "87c9cfc8-757b-45a9-8e3a-b879cb53f459"
}

resource "azurerm_resource_group" "rg-01" {
  name     = var.rgname-01
  location = "Central India"
}


data "azurerm_key_vault" "kv" {
  name                = "kv-ci-hub-d-01"
  resource_group_name = "rg-ci-hub-net-01"
}


data "azurerm_key_vault_secret" "kv-client-secret" {
  name         = "sp-tf-01"
  key_vault_id = data.azurerm_key_vault.kv.id
}
output "secret_value" {
  value     = data.azurerm_key_vault_secret.kv-client-secret.value
  sensitive = true
}


output "rg-name" {
  value = azurerm_resource_group.rg-01.id
}
