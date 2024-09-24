resource "null_resource" "post" {
  triggers = module.frontdoor
  provisioner "local-exec" {
    command = <<-EOF
NAME=$(az network private-link-service show --name ${module.frontdoor.private_link_service_name} --resource-group ${module.resource_group.name} --query "privateEndpointConnections[0].name");
az network private-endpoint-connection approve --resource-group ${module.resource_group.name} --resource-name ${module.frontdoor.private_link_service_name}  --name $NAME --type Microsoft.Network/privateLinkServices
EOF
  }
}