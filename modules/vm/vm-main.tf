variable "resource_group_name" {}
variable "location" {}
variable "windows_vms" {}
variable "subnet_ids" {}

resource "azurerm_network_interface" "vm_nic" {
  for_each = {
    for nic in flatten([
      for vm_key, vm in var.windows_vms : [
        for nic_key, nic in vm.nics : merge(nic, { vm_key = vm_key, nic_key = nic_key })
      ]
    ]) : 
    "${nic.vm_key}-${nic.nic_key}" => nic
  }

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal-ipconfig"
    subnet_id                     = var.subnet_ids[each.value.join_subnet_key]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = var.windows_vms

  name                = "vm-${each.key}-prod"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size

  admin_username      = "azureuser"
  admin_password      = "!QAZ2wsx3edc"
  network_interface_ids = [
    for nic_key, nic in each.value.nics : azurerm_network_interface.vm_nic["${each.key}-${nic_key}"].id
  ]
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${each.key}-osdisk"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = each.value.os_image   # 例: "2019-Datacenter"
    version   = "latest"
  }
}