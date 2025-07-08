variable "resource_group_name" {}
variable "location" {}
variable "system-name" {}
variable "lb" {}
variable "nic_info" {}

locals {
  lb_targer_nics = {
    for nic_key, nic in var.nic_info : 
    nic_key => {
      nic = nic.id
      name             = nic.name
      join_subnet_key  = nic.join_subnet_key
      public_ip        = nic.public_ip
      lb_flag          = nic.lb_flag
    } if nic.lb_flag == true
  }
}


resource "azurerm_public_ip" "az_pip" {
  name                = "pip-lbe-prod"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "az_lb" {
  name                = "lbe-${var.system-name}-prod"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "lbePublicIPAddress"
    public_ip_address_id = azurerm_public_ip.az_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "az_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.az_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "az_lb_backend_address_pool_association" {
  for_each = local.lb_targer_nics
  network_interface_id    = each.value.nic
  ip_configuration_name   = "vm_ip_configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.az_lb_backend_pool.id
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.az_lb.id
  name                = "http-running-probe"
  port                = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.az_lb.id
  name                           = "lb-rule-http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.az_lb_backend_pool.id]
  frontend_ip_configuration_name = "lbePublicIPAddress"
  probe_id                       = azurerm_lb_probe.lb_probe.id
}
