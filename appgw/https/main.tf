locals {
  label = "appgw"
  backend_address_pool_name      = "${local.label}-beap"
  frontend_port_name             = "${local.label}-feport"
  frontend_ip_configuration_name = "${local.label}-feip"
  http_setting_name              = "${local.label}-be-htst"
  listener_name                  = "${local.label}-httplstn"
  request_routing_rule_name      = "${local.label}-rqrt"
  redirect_configuration_name    = "${local.label}-rdrcfg"
  ssl_cert = "${local.label}-sslcert"
  rewrite_rule_set_name = "${local.label}-rewrite"
}

module "pip4appgw" {
  source = "../../pip"
  rg_location = var.rg_location
  rg_name = var.rg_name
}

resource "azurerm_application_gateway" "network" {
  name                = "appgw-${uuid()}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1 // or autoscale_configuration
  }
  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }
  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = module.pip4appgw.public_ip_id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = var.target_ip_addresses
  }

  // ssl_certificate
  // ssl_profile
  // // ssl_policy(optional)
  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name = local.ssl_cert
  }

  ssl_certificate {
    name     = local.ssl_cert
    data     = filebase64(var.pfx_path)
    password = var.pfx_password
  }

  backend_http_settings {
    name                  = local.http_setting_name
    port                  = 80
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
  }

  request_routing_rule {
    priority = 4
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    rewrite_rule_set_name = local.rewrite_rule_set_name
  }
  // this is optional
  rewrite_rule_set {
    name = local.rewrite_rule_set_name
    rewrite_rule {
      name = "${local.rewrite_rule_set_name}-01"
      rule_sequence = 1
      condition {
        variable = "request_scheme"
        pattern = "https"
        ignore_case = true
      }
      request_header_configuration {
        header_name = "X-Forwarded-Proto"
        header_value = "https"
      }
    }
  }
}