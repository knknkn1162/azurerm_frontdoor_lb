resource "random_integer" "idx" {
  min = 10
  max = 256
}
locals {
  private_ip_idx = random_integer.idx.result
}

module "frontdoor" {
  source = "./frontdoor"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  ilb_subnet_id = module.subnets.ids["ilb"]
  frontdoor_subnet_id =  module.subnets.ids["private_link_service"]
  frontdoor_private_ip = cidrhost(var.frontdoor_cidr, local.private_ip_idx)
  # ip
  backend_nic_ids = [
    module.nic4vm1.id,
    module.nic4vm2.id,
  ]
  nic_ip_configuration_name = local.nic_ip_configuration_name
  subscription_id = var.subscription_id
  vnet_id = module.vnetwork.id
  endpoint_prefix = var.frontdoor_dns_prefix
}

# module "ilb" {
#   source = "./frontdoor/ilb"
#   rg_location = module.resource_group.location
#   rg_name = module.resource_group.name
#   subnet_id = module.subnets.ids["ilb"]
#   # ilb_subnet_id = module.subnets.ids["ilb"]
#   # frontdoor_subnet_id =  module.subnets.ids["private_link_service"]
#   #frontdoor_private_ip = cidrhost(var.frontdoor_cidr, local.private_ip_idx)
#   # ip
#   backend_nic_ids = [
#     module.nic4vm1.id,
#     module.nic4vm2.id,
#   ]
#   nic_ip_configuration_name = local.nic_ip_configuration_name
#   #subscription_id = var.subscription_id
#   vnet_id = module.vnetwork.id
#   #endpoint_prefix = var.frontdoor_dns_prefix
# }