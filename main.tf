provider   "azurerm"   { 
    version = "=3.0.1"
    features {}
}

resource   "azurerm_virtual_network"   "modulo-linux-vnet"   {
    name = "modulo-linux-vnet"
    address_space = [ "10.0.0.0/16" ]
    location = var.region
    resource_group_name = var.resource_group
}

resource   "azurerm_subnet"   "modulo-linux-subnet"   {
    name = "modulo-linux-subnet"
    resource_group_name = var.resource_group
    virtual_network_name = azurerm_virtual_network.modulo-linux-vnet.name
    address_prefixes     = ["10.0.2.0/24"]
}

resource   "azurerm_public_ip"   "modulo-linux-publicip"   {
    name = "modulo-linux-publicip"
    location = var.region
    resource_group_name = var.resource_group
    allocation_method = "Dynamic"
    sku = "Basic"
}

resource   "azurerm_network_interface"   "modulo-linux-nic"   {
    name = "modulo-linux-nic"
    location = var.region
    resource_group_name = var.resource_group

    ip_configuration   {
        name = "modulo-linux-ipconfig"
        subnet_id = azurerm_subnet.modulo-linux-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.modulo-linux-publicip.id
    }
}

resource   "azurerm_linux_virtual_machine"   "modulo-linux-virtual-machine"   {
    name                    =   "modulo-linux-virtual-machine"
    location                =   var.region
    resource_group_name     =   var.resource_group
    network_interface_ids   =   [ azurerm_network_interface.modulo-linux-nic.id ]
    size                    =   "Standard_DS1_v2" # 1 vcpu, 3.5G memory $49,57/month (15/11/2022)
    admin_username          =   var.user

    admin_ssh_key {
        username   = var.user
        public_key = file("${path.cwd}/azure_modulo_linux.pub")
    }

    source_image_reference   {
        publisher   =   "Canonical"
        offer       =   "UbuntuServer"
        sku         =   "18.04-LTS"
        version     =   "latest"
    }

    os_disk   {
        caching                 =   "ReadWrite"
        storage_account_type    =   "Standard_LRS"
    }

}