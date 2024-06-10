terraform {
  required_providers {
    azurerm = {
      
        }
  }
}
provider "azurerm" {
  features {}
  
  client_id = "60db1087-1755-440e-8ae6-f676a8d0fcda"
  client_secret = var.client_secret
  tenant_id = "f1c8c522-f8de-4f09-bfc8-da5855540766"
  subscription_id = "157d3c55-83f1-493f-8b06-472400ac04be"
}