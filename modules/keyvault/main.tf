data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Delete",
      "Create",
      "Update",
      "Import",
      "GetRotationPolicy",
      "Purge",
      "Recover"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge"
    ]

    storage_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Update"
    ]
  }
}

output "keyvault_id" {
  value = azurerm_key_vault.keyvault.id
}
