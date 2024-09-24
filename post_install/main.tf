variable "private_link_service_name" {
  type = string
}

variable "rg_name" {
  type = string
}

resource "null_resource" "post" {
  provisioner "local-exec" {
    interpreter = [ "/bin/bash", "-c" ]
    command = <<-EOF
NAME=$(az network private-link-service show --name ${var.private_link_service_name} --resource-group ${var.rg_name} --query 'privateEndpointConnections[0].name' --output tsv);
az network private-endpoint-connection approve --resource-group ${var.rg_name} --resource-name ${var.private_link_service_name} --name $NAME --type Microsoft.Network/privateLinkServices
EOF
  }
}