# variable "resource_group_name" {}
# variable "location" {}
# variable "vnet_name" {}
# variable "bastion-address-prefix" {}
# variable "bastion-sku" {}

# resource "azurerm_subnet" "az-bastion-subnet" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.vnet_name
#   address_prefixes     = ["${var.bastion-address-prefix}"]
# }

# resource "azurerm_public_ip" "az-bastion-pip" {
#   name                = "bastionpip"
#   location            = var.location
#   resource_group_name  = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "az-bastion-host" {
#   name                = "azbastionhost"
#   location            = var.location
#   resource_group_name  = var.resource_group_name
#   sku                = var.bastion-sku

#   ip_configuration {
#     name                 = "bastion-ipconfiguration"
#     subnet_id            = azurerm_subnet.az-bastion-subnet.id
#     public_ip_address_id = azurerm_public_ip.az-bastion-pip.id
#   }
# }