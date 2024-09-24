variable "rg_name" {
  type = string
}

variable "vn_name" {
  type = string
}

variable "label2address_prefixes" {
  type = map(string)
}

variable "service_endpoints" {
  type = list(string)
  default = []
}

# subnet resources must be created all at once
resource "azurerm_subnet" "example" {
  for_each = var.label2address_prefixes
  name = (lower(each.key) == "bastion") ? "AzureBastionSubnet" : "subnet-${each.key}"
  resource_group_name = var.rg_name
  virtual_network_name = var.vn_name
  address_prefixes = [each.value]
  service_endpoints    = var.service_endpoints
  # for frontdoor.private_link settings
  # # When configuring Azure Private Link service,
  # # the explicit setting private_link_service_network_policies_enabled must be set to false in the subnet
  # # since Private Link Service does not support network policies like user-defined Routes and Network Security Groups.
  # # This setting only affects the Private Link service.
  private_link_service_network_policies_enabled = replace(lower(each.key), "_", "") != "privatelinkservice" 
}


output "ids" {
  value = {for key, val in azurerm_subnet.example: key => val.id}
}

output "names" {
  value = {for key, val in azurerm_subnet.example: key => val.name}
}