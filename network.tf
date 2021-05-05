resource "azurerm_virtual_network" "t128_vnet" {
    name = "Terraform_test"
    location = data.azurerm_resource_group.pre_defined.location
    resource_group_name = var.azure_resource_group_name
    address_space = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "management" {
    name = "Management_network"
    resource_group_name = var.azure_resource_group_name
    virtual_network_name = azurerm_virtual_network.t128_vnet.name
    address_prefixes = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "conductor1" {
    name                = "terraform_test_conductor1"
    resource_group_name = var.azure_resource_group_name
    location            = data.azurerm_resource_group.pre_defined.location
    allocation_method   = "Static"
}

resource "azurerm_public_ip" "conductor2" {
    name                = "terraform_test_conductor2"
    resource_group_name = var.azure_resource_group_name
    location            = data.azurerm_resource_group.pre_defined.location
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "conductor1_management" {
  name                = "conductor1_management"
  location            = data.azurerm_resource_group.pre_defined.location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.conductor1.id
  }
}

resource "azurerm_network_interface" "conductor2_management" {
  name                = "conductor2_management"
  location            = data.azurerm_resource_group.pre_defined.location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.conductor2.id
  }
}
