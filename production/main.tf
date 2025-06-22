#リソースグループの定義
resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.system-name}-prod-001"
  location = "japaneast"
}

module "bastion" {
  source = "./modules/bastion"

  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  vnet_name                = module.vnet.vnet_name
  bastion-address-prefix   = var.bastion-address-prefix
  bastion-sku              = var.bastion-sku
}

#各モジュールに渡したい設定値を記載
module "db" {
  source = "./modules/db"

  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  mssql_resource_name = "${var.system-name}"
}

module "lb" {
  source = "./modules/lb"
}

module "monitor" {
  source = "./modules/monitor"
}

module "vm" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  windows_vms = var.windows_vms
  subnet_ids = module.vnet.subnet_ids
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  vnets = var.vnets
  subnets = var.subnets
}