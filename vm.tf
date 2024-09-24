locals {
  nic_ip_configuration_name = "nic-ipconfig"
}
module "vm1" {
  source = "./ubuntu_vm"
  os_disk_type = "Standard_LRS"
  spec = "Standard_B2s"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  nic_id = module.nic4vm1.id
  password = var.password
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
echo "This is server1" > /var/www/html/index.html
EOF
}

module "nic4vm1" {
  source = "./nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["vm"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}

module "vm2" {
  source = "./ubuntu_vm"
  os_disk_type = "Standard_LRS"
  spec = "Standard_B2s"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  nic_id = module.nic4vm2.id
  password = var.password
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
echo "This is server2" > /var/www/html/index.html
EOF
}

module "nic4vm2" {
  source = "./nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["vm"]
  ip_configuration_name = local.nic_ip_configuration_name
  is_public = false
}