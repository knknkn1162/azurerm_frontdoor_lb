variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

# Create Public IPs
module "pip" {
  source = "../pip"
  rg_location = var.rg_location
  rg_name = var.rg_name
}

# Create a NAT Gateway for outbound internet access of the Virtual Machines in the Backend Pool of the Load Balancer
resource "azurerm_nat_gateway" "my_nat_gateway" {
  name = "nat-${uuid()}"
  location = var.rg_location
  resource_group_name = var.rg_name
  sku_name = "Standard"
}

# Associate one of the Public IPs to the NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "my_nat_gateway_ip_association" {
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
  public_ip_address_id = module.pip.public_ip_id
}

# Associate the NAT Gateway to subnet
resource "azurerm_subnet_nat_gateway_association" "my_nat_gateway_subnet_association" {
  subnet_id = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
}