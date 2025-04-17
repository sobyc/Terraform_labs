#Azure Generic Load Balancer Module

data "azurerm_resource_group" "rg2" {
  name = "rg-ci-prd-spoke-01"
}

output "rg-spoke1" {
  value = data.azurerm_resource_group.rg2.name
}
data "azurerm_resource_group" "rg3" {
  name = "rg-ci-prd-spoke-02"
}

output "rg-spoke2" {
  value = data.azurerm_resource_group.rg3.name
}

resource "azurerm_availability_set" "aset-01" {
  name                = "aset-01"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  tags = {
    environment = "Production"
  }
}


resource "azurerm_availability_set" "aset-02" {
  name                = "aset-02"
  location            = data.azurerm_resource_group.rg3.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  tags = {
    environment = "Production"
  }
}