resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.sa_name}01112233445"
  resource_group_name      = var.resource_group_name
  location                 = var.sa_location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}