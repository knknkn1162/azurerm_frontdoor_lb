
output "hostname" {
  value = azurerm_cdn_frontdoor_endpoint.example.host_name
}

output "private_ip" {
  # var.frontdoor_private_ip
  value = azurerm_private_link_service.example.nat_ip_configuration[0].private_ip_address
}

output "ilb_private_ip" {
  value = module.ilb.private_ip
}

output "private_link_service_name" {
  value = azurerm_private_link_service.example.name
}