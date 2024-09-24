locals {
  label = "appgw"
  frontend_ip_configuration_name = "${local.label}-feip"
}

resource "azurerm_lb" "example" {
  name                = "ilb-${uuid()}"
  sku                 = "Standard"
  location            = var.rg_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    # frontend IP conf must reference either a Subnet, Public IP Address or Public IP Prefix.
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = "IPv4"
  }
}

resource "azurerm_lb_probe" "my_lb_probe" {
  name = var.rg_name
  loadbalancer_id = azurerm_lb.example.id
  port = 80
}

resource "azurerm_lb_backend_address_pool" "example" {
  name            = "backend-pool"
  loadbalancer_id = azurerm_lb.example.id
}

# Associate each Network Interface to the Backend Pool of the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "example" {
  for_each = { for idx, val in var.backend_nic_ids : idx => val }
  network_interface_id    = each.value
  ip_configuration_name   = var.nic_ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_lb_rule" "example" {
  loadbalancer_id            = azurerm_lb.example.id
  name                       = "example-rule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name  = local.frontend_ip_configuration_name
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
}




output "private_ip" {
  value = azurerm_lb.example.private_ip_address
}

output "frontend_ip_configuration_id" {
  value = azurerm_lb.example.frontend_ip_configuration[0].id
}