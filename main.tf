terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-01" {
  name     = "rg-ci-p-odoo-01"
  location = "Central India"
}

