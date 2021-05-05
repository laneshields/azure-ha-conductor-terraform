variable "azure_resource_group_name" {}
variable "t128_instance_size" { default = "Standard_D2s_v3"}
variable "t128_linux_admin_username" { default = "t128"}
variable "t128_admin_pw_hash" { default = "$6$JEmS0I7bNwkO96uX$8Wz.qrafYlE9fZnQu3WFbp4Nhc.Da4u010OSrUzaNzAR7OESfWE1cBEeDP5kVZZjnsv/Ez6VPCRoMV0O3GdET/" }
variable "node1_name" { default = "node1" }
variable "node2_name" { default = "node2" }
variable "router_name" { default = "conductor" }

### Configure the Azure Provider
provider "azurerm" {
  features {}
}

### Load key data
data "template_file" "master_pem" {
  template = file("./master.pem")
}

data "template_file" "master_pub" {
  template = file("./master.pub")
}

data "template_file" "conductor1_pdc_ssh_key" {
  template = file("./conductor1_pdc_ssh_key")
}

data "template_file" "conductor1_pdc_ssh_key_pub" {
  template = file("./conductor1_pdc_ssh_key.pub")
}

data "template_file" "conductor2_pdc_ssh_key" {
  template = file("./conductor2_pdc_ssh_key")
}

data "template_file" "conductor2_pdc_ssh_key_pub" {
  template = file("./conductor2_pdc_ssh_key.pub")
}


### Prepare cloud-init
data "template_file" "conductor1" {
  template = file("conductor.tpl")

  vars = {
    node_ip = azurerm_network_interface.conductor1_management.private_ip_address
    peer_ip = azurerm_network_interface.conductor2_management.private_ip_address
    node_name = var.node1_name
    peer_node_name = var.node2_name
    router_name = var.router_name
    admin_password_hash = var.t128_admin_pw_hash
    master_pem = indent(4, data.template_file.master_pem.rendered)
    master_pub = indent(4, data.template_file.master_pub.rendered)
    pdc_key = indent(4, data.template_file.conductor1_pdc_ssh_key.rendered)
    pdc_key_pub = indent(4, data.template_file.conductor1_pdc_ssh_key_pub.rendered)
    pdc_peer_key_pub = indent(4, data.template_file.conductor2_pdc_ssh_key_pub.rendered)
  }
}

data "template_cloudinit_config" "conductor1" {
  gzip = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.conductor1.rendered
  }
}

data "template_file" "conductor2" {
  template = file("conductor.tpl")

  vars = {
    node_ip = azurerm_network_interface.conductor2_management.private_ip_address
    peer_ip = azurerm_network_interface.conductor1_management.private_ip_address
    node_name = var.node2_name
    peer_node_name = var.node1_name
    router_name = var.router_name
    admin_password_hash = var.t128_admin_pw_hash
    master_pem = indent(4, data.template_file.master_pem.rendered)
    master_pub = indent(4, data.template_file.master_pub.rendered)
    pdc_key = indent(4, data.template_file.conductor2_pdc_ssh_key.rendered)
    pdc_key_pub = indent(4, data.template_file.conductor2_pdc_ssh_key_pub.rendered)
    pdc_peer_key_pub = indent(4, data.template_file.conductor1_pdc_ssh_key_pub.rendered)
  }
}

data "template_cloudinit_config" "conductor2" {
  gzip = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.conductor2.rendered
  }
}

data "azurerm_resource_group" "pre_defined" {
    name = var.azure_resource_group_name
}
