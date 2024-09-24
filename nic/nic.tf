locals {
  name = "nic-${uuid()}"
}

resource "azurerm_network_interface" "example" {
  name = local.name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name = var.ip_configuration_name
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = var.is_public ? module.pip.public_ip : null
  }
}