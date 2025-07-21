# for文の結果
# {
#   nic01 = {"name" = "ap01-nic", "join_subnet_key" = "subnet02", "public_ip" = false, "lb_flag" = false, "nic_key" = "nic01"}
#   nic01-2 = {"name" = "ap01-nic-2", "join_subnet_key" = "subnet02", "public_ip" = false, "lb_flag" = false, "nic_key" = "nic01-2"}
#   nic02 = {"name" = "db01-nic", "join_subnet_key" = "subnet02", "public_ip" = false, "lb_flag" = false, "nic_key" = "nic02"}
#   nic03 = {"name" = "web01-nic", "join_subnet_key" = "subnet01", "public_ip" = false, "lb_flag" = true, "nic_key" = "nic03"}
#   nic04 = {"name" = "web02-nic", "join_subnet_key" = "subnet01", "public_ip" = false, "lb_flag" = true, "nic_key" = "nic04"}
# }

locals {
  nic_configs = {
    for nic in flatten([
      for vm_key, vm in var.windows_vms : [
        for nic_key, nic in vm.nics : 
        merge(nic, { vm_key = vm_key, nic_key = nic_key })
      ]
    ]) : 
    "${nic.vm_key}-${nic.nic_key}" => nic
  }
}

output "nic_ids" {
  value = {
    for nic_key, nic in azurerm_network_interface.vm_nic : nic_key => {
      id               = nic.id
      name             = local.nic_configs[nic_key].name
      join_subnet_key  = local.nic_configs[nic_key].join_subnet_key
      public_ip        = local.nic_configs[nic_key].public_ip
      lb_flag          = local.nic_configs[nic_key].lb_flag
    }
  }
}

output "vm_ids" {
  description = "Map of VM IDs for monitoring purposes"
  value = {
    for vm_key, vm in azurerm_windows_virtual_machine.windows_vm : vm_key => vm.id
  }
}