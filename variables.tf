variable "rg-name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Location"
}

variable "virtual_network_name" {
  description = "Virtual Network name"
}

variable "bastion-name" {
  description = "Name of bastion host"
  default = "bastion-host"
}

variable "address_prefixes" {
  description = "for the subnet"
}