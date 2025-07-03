variable "mz_nsgs" {}
variable "resource_group_name" {}
variable "location" {}
variable "subnet_ids" {}

locals {
  nsg_subnet_pairs = flatten([
    for nsg_key, nsg in var.mz_nsgs : [
      for subnet_key in nsg.attached_subnets_key : {
        nsg_key    = nsg_key
        subnet_key = subnet_key
      }
    ]
  ])
}


resource "azurerm_network_security_group" "az_mz_nsg" {
  for_each = var.mz_nsgs
  name                = "nsg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
    name                       = security_rule.key
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = {
    for nsg_assoc_pair in local.nsg_subnet_pairs :
    "${nsg_assoc_pair.nsg_key}-${nsg_assoc_pair.subnet_key}" => nsg_assoc_pair
  }

  subnet_id                 = var.subnet_ids[each.value.subnet_key]
  network_security_group_id = azurerm_network_security_group.az_mz_nsg[each.value.nsg_key].id
}