variable "resource_group_name" {}
variable "location" {}
variable "mssql_resource_name" {}

resource "azurerm_mssql_server" "az-sqlserver" {
  name                         = "sqldb-${var.mssql_resource_name}-prod"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "ytoyoda8-administrator"
  administrator_login_password = "!QAZ2wsx3edc"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_firewall_rule" "example" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.example.id
  start_ip_address = "10.0.17.62"
  end_ip_address   = "10.0.17.62"
}