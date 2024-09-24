output "public_ip_id" {
    value = azurerm_public_ip.example.id
}

output "public_ip" {
    value = azurerm_public_ip.example.ip_address
}

output "fqdn" {
  value = azurerm_public_ip.example.fqdn
}

output "domain" {
  value = azurerm_public_ip.example.domain_name_label
}

output "name" {
  value = azurerm_public_ip.example.name
}