# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.10.0"
    }
  }
}

locals {
  rg_name = "rg-${var.prefix}"
  vnet_name = "vnet-${var.prefix}"
  nsg_name = "nsg-${var.prefix}"
  vm_name = "vm-${var.prefix}"
  vm_nic_name = "nic-${local.vm_name}"
  vnet_address_space = ["10.1.0.0/16"]
  subnet_prefix = ["10.1.0.0/24"]
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  special = false
}

# Create a resource group
resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = var.region
  tags = var.tags
}

# create a virtual network
resource "azurerm_virtual_network" "myvnet" {
  name = local.vnet_name
  address_space = local.vnet_address_space
  location = var.region
  resource_group_name = azurerm_resource_group.myrg.name
}

# create a default subnet in the virtual network
resource "azurerm_subnet" "mysubnet" {
  name = "default"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = local.subnet_prefix
  service_endpoints = [ "Microsoft.Storage" ]
}

# create network security group 

resource "azurerm_network_security_group" "mynsg" {
  name = local.nsg_name
  location = var.region
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
        name                       = "Deny all incoming"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# associate nsg with subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.mysubnet.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}


# create a storage account with unique name

resource "azurerm_storage_account" "mysa" {
  name = "sa${var.prefix}${random_string.random.result}"
  resource_group_name = azurerm_resource_group.myrg.name
  location = var.region
  account_tier = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.mysubnet.id]
  }
}

output "sa_name" {
  value = azurerm_storage_account.mysa.name
}

# Create a NIC for ubuntu VM
resource "azurerm_network_interface" "mynic" {
  name                = local.vm_nic_name
  location            = var.region
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a ubuntu VM


resource "azurerm_linux_virtual_machine" "myubuntu" {
  name                = local.vm_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = var.region
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.mynic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
