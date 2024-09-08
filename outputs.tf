output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = module.vm.vm_id
}

output "keyvault_id" {
  description = "The ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = module.network.subnet_id
}

