module "resource_group" {
    source = "./resource_group"
    location = var.rg_location
}

module "vnetwork" {
    source = "./vnetwork"
    rg_location = module.resource_group.location
    rg_name = module.resource_group.name
    address_space = [var.vnet_cidr]
}


module "subnets" {
  source = "./subnets"
  rg_name = module.resource_group.name
  vn_name = module.vnetwork.name
  label2address_prefixes = {
    "ilb" = var.ilb_cidr
    "vm" = var.vm_cidr
    "private_link_service" = var.frontdoor_cidr
  }
}

# for private vm
module "nat" {
  source = "./nat"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  subnet_id = module.subnets.ids["vm"]
}