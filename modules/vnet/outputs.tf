output "subnet_ids" {
  value = { for subnet_key, subnet in azurerm_subnet.subnet : subnet_key => subnet.id }
}
output "vnet_names" {
  value = { for vnet_key, vnet in azurerm_virtual_network.vnet : vnet_key => vnet.name }
}

output "vnet_ids" {
  value = { for vnet_key, vnet in azurerm_virtual_network.vnet : vnet_key => vnet.id }
}