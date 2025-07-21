variable "resource_group_name" {}
variable "location" {}
variable "loganalyticsworkspace" {}
variable "dce" {
  type = object({
    name = string
  })
  description = "Data Collection Endpoint configuration"
}
variable "vm_ids" {}

resource "azurerm_log_analytics_workspace" "az_log_analytics_workspace" {
  name                = var.loganalyticsworkspace.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.loganalyticsworkspace.retention_in_days
}

resource "azurerm_monitor_data_collection_endpoint" "az_dce" {
  name                = var.dce.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_monitor_data_collection_rule" "az_vm_monitoring_dcr" {
  name                        = "dcr-vm-monitoring-${var.location}"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.az_dce.id
  kind                        = "Windows"

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.az_log_analytics_workspace.id
      name                  = "destination-log-analytics"
    }
  }

  data_sources {
    # Windowsイベントログの収集設定
    windows_event_log {
      name           = "eventLogsDataSource"
      streams        = ["Microsoft-WindowsEvent"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
    }

    # CPU、メモリ、ディスクのパフォーマンスカウンター
    performance_counter {
      name                          = "perfCounterDataSource"
      streams                       = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        # CPU使用率
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Processor(_Total)\\% Processor Time",
        
        # メモリ使用率
        "\\Memory\\Available Bytes",
        "\\Memory\\% Committed Bytes In Use",
        "\\Memory\\Committed Bytes",
        
        # ディスク使用率
        "\\LogicalDisk(_Total)\\% Disk Time",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\LogicalDisk(_Total)\\Free Megabytes",
        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
        
        # ネットワーク
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Bytes Sent/sec"
      ]
    }
  }

  # データフローの設定
  data_flow {
    streams      = ["Microsoft-WindowsEvent"]
    destinations = ["destination-log-analytics"]
  }

  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-InsightsMetrics"]
    destinations = ["destination-log-analytics"]
  }

  description = "Data Collection Rule for Windows VM monitoring - Events and Performance"
  
  tags = {
    purpose = "vm-monitoring"
    environment = "production"
  }

  depends_on = [
    azurerm_log_analytics_workspace.az_log_analytics_workspace
  ]
}

# DCRとVMの関連付け
resource "azurerm_monitor_data_collection_rule_association" "az_vm_dcr_association" {
  for_each = var.vm_ids

  name                    = "dcra-${each.key}"
  target_resource_id      = each.value
  data_collection_rule_id = azurerm_monitor_data_collection_rule.az_vm_monitoring_dcr.id
  description             = "Association of DCR with VM ${each.key}"
}

# Azure Monitor Agent拡張機能をVMにインストール
resource "azurerm_virtual_machine_extension" "monitor_agent" {
  for_each = var.vm_ids

  name                       = "AzureMonitorWindowsAgent-${each.key}"
  virtual_machine_id         = each.value
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true

  # AMAは設定不要（DCRで管理）
  settings = jsonencode({})

  tags = {
    purpose     = "monitoring"
    environment = "production"
  }

  # Log Analytics WorkspaceとDCRが作成された後にインストール
  depends_on = [
    azurerm_log_analytics_workspace.az_log_analytics_workspace,
    azurerm_monitor_data_collection_rule.az_vm_monitoring_dcr
  ]
}