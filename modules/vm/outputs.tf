locals {
  nic_configs = {
    for nic in flatten([
      for vm_key, vm in var.windows_vms : [
        for nic_key, nic in vm.nics : nic
      ]
    ]) : 
    nic.nic_key => nic
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