locals {
  strid = uuid()
}

module "ilb" {
  source = "./ilb"
  rg_location = var.rg_location
  rg_name = var.rg_name
  subnet_id = var.ilb_subnet_id
  nic_ip_configuration_name = var.nic_ip_configuration_name
  backend_nic_ids = var.backend_nic_ids
  vnet_id = var.vnet_id
}

resource "azurerm_private_link_service" "example" {
  name = "privatelinkservice-${local.strid}"
  resource_group_name = var.rg_name
  location = var.rg_location
  load_balancer_frontend_ip_configuration_ids = [module.ilb.frontend_ip_configuration_id]
  auto_approval_subscription_ids = [var.subscription_id]
  visibility_subscription_ids = [var.subscription_id]
  nat_ip_configuration {
    name                       = "primary"
    subnet_id                  = var.frontdoor_subnet_id
    # generate nic automatically within frontdoor_cidr
    private_ip_address = var.frontdoor_private_ip
    private_ip_address_version = "IPv4"
    primary                    = true
  }
}

resource "azurerm_cdn_frontdoor_profile" "example" {
  # Private Link Service with a Load Balancer the Profile resource in your configuration file
  # must have a depends_on meta-argument which references the azurerm_private_link_service
  depends_on = [azurerm_private_link_service.example]
  name                = "frontdoor-profile-${local.strid}"
  resource_group_name = var.rg_name
  # 'private_link' field can only be configured
  # when the Frontdoor Profile is using a 'Premium_AzureFrontDoor' SKU, got "Standard_AzureFrontDoor"
  sku_name            = "Premium_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_origin_group" "example" {
  name                     = "frontdoor-origin-group-${local.strid}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
  session_affinity_enabled = false
  # set to default
  load_balancing {}
}

resource "azurerm_cdn_frontdoor_endpoint" "example" {
  name                     = var.endpoint_prefix
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.example.id
}

resource "azurerm_cdn_frontdoor_origin" "example" {
  name                          = "origin-${local.strid}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
  enabled                       = true

  # Private Link requires that the Front Door Profile this Origin is hosted within is using the SKU Premium_AzureFrontDoor
  # and that the certificate_name_check_enabled field is set to true.
  certificate_name_check_enabled = true
  host_name                      = azurerm_private_link_service.example.nat_ip_configuration[0].private_ip_address
  # priority = 1
  # weight   = 500

  private_link {
    location               = var.rg_location
    private_link_target_id = azurerm_private_link_service.example.id
  }
}

# Please make sure that the originGroup is created successfully and at least one enabled origin is created under the origin group.
resource "azurerm_cdn_frontdoor_route" "example" {
  name                          = "frontdoor-route-${local.strid}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.example.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.example.id]
  cdn_frontdoor_endpoint_id = azurerm_cdn_frontdoor_endpoint.example.id

  # SSL offloading
  forwarding_protocol    = "HttpOnly"
  patterns_to_match      = ["/*"]
  # If https_redirect_enabled is set to true the supported_protocols field must contain both Http and Https values.
  #https_redirect_enabled = true
  supported_protocols    = ["Http", "Https"]
  # default to true
  # link_to_default_domain = true
  # enabled=true
}


data "azurerm_private_link_service_endpoint_connections" "example" {
  depends_on = [ azurerm_cdn_frontdoor_route.example ]
  service_id = azurerm_private_link_service.example.id
  resource_group_name = var.rg_name
}