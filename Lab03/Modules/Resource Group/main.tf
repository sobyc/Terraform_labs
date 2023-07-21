
resource "azurerm_resource_group" "rg-02" {
  name     = "${var.rgname-02}-01"
  location = var.location
}
