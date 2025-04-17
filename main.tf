terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "7a0bf087-e2b9-4fb2-bb79-4ef863e0c025"
}

resource "azurerm_resource_group" "rg-01" {
  name = "rg-ci-p-odoo-01"
  location = "Central India"
}

