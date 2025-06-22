output "subnet_ids" {
  value = { for k, s in azurerm_subnet.subnet : k => s.id }
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet["01"].name
}