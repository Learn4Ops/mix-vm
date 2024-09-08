data "azurerm_storage_account" "storageaccount023412" {
  name                = "storageaccount023412"
  resource_group_name = "existing-rg"
  
}

resource "azurerm_storage_container" "scripts-linux" {
  name                  = "scripts-linux"
  storage_account_name  = data.azurerm_storage_account.storageaccount023412.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "prepare" {
  name                   = "prepare.sh"
  storage_account_name   = data.azurerm_storage_account.storageaccount023412.name
  storage_container_name = azurerm_storage_container.scripts-linux.name
  type                   = "Block"
  source                 = "${path.module}/prepare.sh"
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  size                = "Standard_DS1_v2"
  resource_group_name = var.resource_group_name
  location            = var.location
  network_interface_ids = [
    var.azurerm_network_interfacenicid
  ]
  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    disk_size_gb         = var.os_disk_size_gb
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  admin_username = var.admin_username
  computer_name  = var.vm_name

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key

  }

}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}


resource "azurerm_virtual_machine_extension" "dependencies" {
  name                 = "${var.vm_name}-ext"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROTECTED_SETTINGS
    {
        "storageAccountName": "${data.azurerm_storage_account.storageaccount023412.name}",
        "storageAccountKey": "${data.azurerm_storage_account.storageaccount023412.primary_access_key}"
    }
PROTECTED_SETTINGS

  settings = <<SETTINGS
 {
  "commandToExecute": "sudo sh prepare.sh",
  "fileUris": ["https://${data.azurerm_storage_account.storageaccount023412.name}.blob.core.windows.net/${azurerm_storage_container.scripts-linux.name}/prepare.sh"]
 }
SETTINGS

}
