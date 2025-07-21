variable "resource_group_name" {}
variable "location" {}
variable "storageaccount" {}

resource "azurerm_storage_account" "example" {
  name                     = var.storageaccount.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storageaccount.account_tier
  account_replication_type = var.storageaccount.account_replication_type
}