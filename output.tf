output "fqdn" {
  value = module.frontdoor.hostname
}

output "private_ip" {
  value = module.frontdoor.private_ip
}

output "ilb_private_ip" {
  value = module.frontdoor.ilb_private_ip
}

output "approved_commaand" {
  value = <<-EOF
az network private-endpoint-connection approve --resource-group ${module.resource_group.name} --resource-name ${module.frontdoor.private_link_service_name}  --name ${module.frontdoor.endpoint_connection_name} --type Microsoft.Network/privateLinkServices
EOF
}