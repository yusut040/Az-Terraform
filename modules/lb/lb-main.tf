variable "resource_group_name" {}
variable "location" {}
variable "system-name" {}
variable "lb" {}

resource "azurerm_public_ip" "az_pip" {
  name                = "pip-lbe-prod"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "az_lb" {
  for_each = var.lb
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
  network_interface_id    = azurerm_network_interface.vm_network_interface.id
  ip_configuration_name   = "vm_ip_configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = azurerm_resource_group.resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http-running-probe"
  port                = 80
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = azurerm_resource_group.resource_group.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = local.lb_rule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
  frontend_ip_configuration_name = "lb_public_ip_configuration"
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_dns_a_record" "lb_dns_record" {
  name = local.lb_domain_name
  zone_name = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.resource_group.name
  ttl = 300
  target_resource_id = azurerm_public_ip.lb_public_ip.id
}