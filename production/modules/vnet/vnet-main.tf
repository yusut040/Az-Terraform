variable "resource_group_name" {}
variable "location" {}
variable "vnets"{}
variable "subnets" {}

resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnets
  name                = "vnet-prod-${var.location}-${each.key}"
  address_space       = ["${each.value.address_prefix}"]
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  name                 = "snet-prod-${var.location}-${each.key}"
  address_prefixes     = ["${each.value.address_prefix}"]
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}