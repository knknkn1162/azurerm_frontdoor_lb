variable "private_link_service_name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "endpoint_connection_name" {
  type = string
}

resource "null_resource" "post" {
  provisioner "local-exec" {
    command = <<-EOF
az network private-endpoint-connection approve --resource-group ${var.private_link_service_name} --resource-name ${var.private_link_service_name}  --name ${var.endpoint_connection_name} --type Microsoft.Network/privateLinkServices
EOF
  }
}