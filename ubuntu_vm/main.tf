variable "nic_id" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "spec" {
  type = string
}

variable "password" {
  type = string
}

variable "user_data" {
  type = string
  default = ":"
}

variable "os_disk_type" {
  type = string
}

variable "os_disk_size" {
  type = number
  default = null
}

resource "azurerm_linux_virtual_machine" "example" {
  name = "vm-${uuid()}"
  resource_group_name =var.rg_name
  location = var.rg_location
  size = var.spec
  network_interface_ids = [var.nic_id]
  admin_username = "adminuser"
  disable_password_authentication = false
  admin_password = var.password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
    disk_size_gb = var.os_disk_size
  }
  user_data = base64encode(var.user_data)


  # ubuntu 22.04s
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "user_data" {
  value = var.user_data
}