resource "azurerm_linux_virtual_machine" "conductor1" {
    name = "terraform-test-conductor1"
    resource_group_name = var.azure_resource_group_name
    location = data.azurerm_resource_group.pre_defined.location
    size = var.t128_instance_size
    admin_username = var.t128_linux_admin_username

    custom_data = data.template_cloudinit_config.conductor1.rendered

    network_interface_ids = [
        azurerm_network_interface.conductor1_management.id
    ]

    admin_ssh_key {
      username = var.t128_linux_admin_username
      public_key = file("~/.ssh/id_rsa.pub")
    }

    plan {
        publisher = "128technology"
        #product = "128technology_conductor_hourly"
        #name = "128technology_conductor_private_452"
        product = "juniper_session_smart_networking"
        name = "juniper_session_smart_networking_512_private"
    }

    source_image_reference {
        publisher = "128technology"
        #offer = "128technology_conductor_hourly"
        #sku = "128technology_conductor_private_452"
        offer = "juniper_session_smart_networking"
        sku = "juniper_session_smart_networking_512_private"
        version = "latest"
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
    }
}

resource "azurerm_linux_virtual_machine" "conductor2" {
    name = "terraform-test-conductor2"
    resource_group_name = var.azure_resource_group_name
    location = data.azurerm_resource_group.pre_defined.location
    size = var.t128_instance_size
    admin_username = var.t128_linux_admin_username

    custom_data = data.template_cloudinit_config.conductor2.rendered

    network_interface_ids = [
        azurerm_network_interface.conductor2_management.id
    ]

    admin_ssh_key {
      username = var.t128_linux_admin_username
      public_key = file("~/.ssh/id_rsa.pub")
    }

    plan {
        publisher = "128technology"
        #product = "128technology_conductor_hourly"
        #name = "128technology_conductor_private_452"
        product = "juniper_session_smart_networking"
        name = "juniper_session_smart_networking_512_private"
    }

    source_image_reference {
        publisher = "128technology"
        #offer = "128technology_conductor_hourly"
        #sku = "128technology_conductor_private_452"
        offer = "juniper_session_smart_networking"
        sku = "juniper_session_smart_networking_512_private"
        version = "latest"
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "StandardSSD_LRS"
    }
}
