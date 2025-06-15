variable "resource_group_name" {}
variable "location" {}
variable "windows_vm" {}
variable "vm_nic" {}
variable "subnet_ids" {}

resource "azurerm_network_interface" "vm_nic" {
  for_each = var.vm_nic
  name                = "nic-${var.value.name}-prod"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal-ipconfig"
    subnet_id                     = var.subnet_ids
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each = var.windows_vm

  name                = "vm-${each.value.name}-prod"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size

  admin_username      = "azureuser"
  admin_password      = "!QAZ2wsx3edc"
  network_interface_ids = var.subnet_ids
  
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