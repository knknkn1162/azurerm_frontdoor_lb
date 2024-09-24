variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "endpoint_prefix" {
  type = string
}

variable "ilb_subnet_id" {
  type = string
}

variable "frontdoor_subnet_id" {
  type = string
}

variable "frontdoor_private_ip" {
  type = string
}

variable "vnet_id" {
  type = string
}
variable "subscription_id" {
  type = string
}

variable "nic_ip_configuration_name" {
  type = string
}

variable "backend_nic_ids" {
  type = list(string)
}