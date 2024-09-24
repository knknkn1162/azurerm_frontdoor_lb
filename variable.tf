variable "rg_location" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "vm_cidr" {
  type = string
}

variable "ilb_cidr" {
  type = string
}

variable "frontdoor_cidr" {
  type = string
}

variable "password" {
  type = string
}

variable "subscription_id" {
  type = string
}

# variable "pfx_password" {
#   type = string
# }

# variable "pfx_path" {
#   type = string
# }

variable "frontdoor_dns_prefix" {
  type = string
}