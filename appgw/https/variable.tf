variable "subnet_id" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "target_ip_addresses" {
  type = list(string)
}

variable "pfx_password" {
  type = string
}

variable "pfx_path" {
  type = string
}
