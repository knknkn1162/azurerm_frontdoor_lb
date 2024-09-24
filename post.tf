module "post_install" {
  source = "./post_install"
  rg_name = module.resource_group.name
  private_link_service_name = module.frontdoor.private_link_service_name
  endpoint_connection_name = module.frontdoor.endpoint_connection_name
  depends_on = [ module.frontdoor ]
}