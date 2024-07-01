
resource "azurerm_resource_group" "rg-01" {
  name     = "rg-${var.location}-${var.env}-${var.hub-base}-01"
  location = var.location
}

resource "azurerm_resource_group" "rg-02" {
  name     = "rg-${var.location}-${var.env}-${var.spoke-base}-01"
  location = var.location
}

resource "azurerm_resource_group" "rg-03" {
  name     = "rg-${var.location}-${var.env}-${var.spoke-base}-02"
  location = var.location
}
