variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}
variable "vm_name" {
  description = "The name of the Network Security Group"
  type        = string
}