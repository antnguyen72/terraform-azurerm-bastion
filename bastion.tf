# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.80.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Subnets
resource "azurerm_subnet" "AzureBastionSubnet" {
  name = "AzureBastionSubnet"
  resource_group_name = var.rg-name
  virtual_network_name = var.virtual_network_name
  address_prefixes = var.address_prefixes
}

resource "azurerm_public_ip" "bastion-public-ip" {
  name = "bastion-public-ip"
  location = var.location
  resource_group_name = var.rg-name
  sku = "Standard"
  allocation_method = "Static"
}

resource "azurerm_bastion_host" "bastion-host" {
  name = var.bastion-name
  location = var.location
  resource_group_name = var.rg-name
  sku = "Standard"
  
  copy_paste_enabled = true
  file_copy_enabled = true
  shareable_link_enabled = true
  tunneling_enabled = true

  ip_configuration {
    name = "bastion-ip-conf"
    subnet_id = azurerm_subnet.AzureBastionSubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-public-ip.id
  }
}

output "subnet_address_prefix" {
  value = azurerm_subnet.AzureBastionSubnet.address_prefixes[0]
}

output "bastion-name" {
  value = var.bastion-name
}