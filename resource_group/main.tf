variable "location" {
  type = string
}

resource "azurerm_resource_group" "example" {
  name = "rg-${uuid()}"
  location = var.location
}

output "name" {
  value = azurerm_resource_group.example.name
}

output "location" {
    value = azurerm_resource_group.example.location
}