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
  vnet_address_space = ["10.1.0.0/16"]
  subnet_prefix = ["10.1.0.0/24"]
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = var.region
  tags = var.tags # tag as key / value pair in variables file
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
}