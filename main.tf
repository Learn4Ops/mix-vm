terraform {
  required_version = ">=0.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "subs-id"
}

locals {
  service_name = "bitbucket-agent"
}


data "azurerm_resource_group" "bitbucket-agent" {
  name = "existing-rg"
}

output "id" {
  value = data.azurerm_resource_group.bitbucket-agent.id
}

module "network" {
  source = "./modules/network"

  location            = data.azurerm_resource_group.bitbucket-agent.location
  resource_group_name = data.azurerm_resource_group.bitbucket-agent.name
  vnet_name           = "${local.service_name}-vnet"
  subnet_name         = "${local.service_name}-subnet"
  nsg_name            = "${local.service_name}-nsg"
  vm_name             = "${local.service_name}-vm"
}

module "keyvault" {
  source = "./modules/keyvault"

  location            = data.azurerm_resource_group.bitbucket-agent.location
  resource_group_name = data.azurerm_resource_group.bitbucket-agent.name
  keyvault_name       = "${local.service_name}-kv"
}

resource "random_string" "admin_username" {
  length  = 12
  special = false
  upper   = true
  lower   = true

}


resource "random_password" "admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
}

resource "azurerm_key_vault_secret" "admin_username" {
  name         = "adminUsername"
  value        = random_string.admin_username.result
  key_vault_id = module.keyvault.keyvault_id
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "adminPassword"
  value        = random_password.admin_password.result
  key_vault_id = module.keyvault.keyvault_id
}



resource "tls_private_key" "adming_ssh_tls" {
    algorithm = "RSA"
    rsa_bits = 4096
}

output "public_key" {
  value = tls_private_key.adming_ssh_tls.public_key_openssh
}

#Store the private key in Key Vault
resource "azurerm_key_vault_secret" "admin_ssh_private_key" {
  name         = "sshPrivateKey"
  value        = tls_private_key.adming_ssh_tls.private_key_pem
  key_vault_id  = module.keyvault.keyvault_id
}

# Store the public key in Key Vault
resource "azurerm_key_vault_secret" "admin_ssh_public_key" {
  name         = "sshPublicKey"
  value        = tls_private_key.adming_ssh_tls.public_key_openssh
  key_vault_id  = module.keyvault.keyvault_id
}


module "vm" {
  source = "./modules/vm"

  admin_username = azurerm_key_vault_secret.admin_username.value
  admin_password = azurerm_key_vault_secret.admin_password.value

  ssh_public_key = azurerm_key_vault_secret.admin_ssh_public_key.value

  location            = data.azurerm_resource_group.bitbucket-agent.location
  resource_group_name = data.azurerm_resource_group.bitbucket-agent.name
  vm_name             = "${local.service_name}-vm"
  azurerm_network_interfacenicid = module.network.nic_id
}
