module "Prod-environment" {
  source = "./env/prod"
}

resource "azurerm_resource_group" "rg-eus-prd" {
  name     = "rg-eus-prd-hub-01"
  location = "East US"
}