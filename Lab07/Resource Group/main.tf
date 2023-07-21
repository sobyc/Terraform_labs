
resource "azurerm_resource_group" "rg-01" {
  name     = "${var.rgname-01}-01"
  location = var.location
}

resource "azurerm_resource_group" "rg-02" {
  name     = "${var.rgname-02}-01"
  location = var.location
}

resource "azurerm_resource_group" "rg-03" {
  name     = "${var.rgname-02}-02"
  location = var.location
}