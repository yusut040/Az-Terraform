variable "system-name" {}

#リソースグループの定義
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.system-name}-prod-001"
  location = "japaneast"
}