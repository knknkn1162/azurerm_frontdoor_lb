variable "domain_prefix" {
  type = string
  default = null
}
variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}


resource "azurerm_public_ip" "example" {
  name                = "pip-${uuid()}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"
  sku = "Standard"
  domain_name_label = var.domain_prefix
  zones = [1,2,3]
}