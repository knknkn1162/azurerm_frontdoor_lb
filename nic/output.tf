output "id" {
    value = azurerm_network_interface.example.id
}

output "ip_configuration_name" {
  value = azurerm_network_interface.example.ip_configuration[0].name
}

output "private_ip" {
    value = azurerm_network_interface.example.private_ip_address
}

output "public_ip_id" {
    value = module.pip.public_ip_id
}

output "public_ip" {
    value = module.pip.public_ip
}

output "fqdn" {
  value = module.pip.fqdn
}

output "domain" {
  value = module.pip.domain
}