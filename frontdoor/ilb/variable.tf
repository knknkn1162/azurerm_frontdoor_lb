variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "subnet_id" {
  type = string
}
variable "vnet_id" {
  type = string
}

variable "nic_ip_configuration_name" {
  type = string
}

variable "backend_nic_ids" {
  type = list(string)
}