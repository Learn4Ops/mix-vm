variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the Virtual Machine"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the Virtual Machine"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "os_disk_size_gb" {
  description = "The size of the OS disk in GB"
  type        = number
  default     = 30
}

variable "image_publisher" {
  description = "The publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "The SKU of the VM image"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "The version of the VM image"
  type        = string
  default     = "latest"
}

variable "location" {
  description = "The Azure region where the VM will be created"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH key required by VM"
  type        = string

}

variable "azurerm_network_interfacenicid" {
  description = "SSH key required by VM"
  type        = string

}
