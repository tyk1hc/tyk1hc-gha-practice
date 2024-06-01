resource "azurerm_disk_encryption_set" "diskencrypt" {
  name                = var.diskencryptionsetname
  location            = var.location
  resource_group_name = var.resource_group_name
  key_vault_key_id    = var.key_vault_key_id
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}



#Access Policy in Key Vault#
resource "azurerm_key_vault_access_policy" "diskencrypt_identity" {
  key_vault_id = var.key_vault_id
  tenant_id = azurerm_disk_encryption_set.diskencrypt.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.diskencrypt.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}



#aks identity Role Assignment to Disk encryption set resource group.
resource "azurerm_role_assignment" "diskencrypt_rg_role_aks_identity" {
  scope                = azurerm_disk_encryption_set.diskencrypt.id
  role_definition_name = "Reader"
  principal_id         = var.aks_managed_identity_principal_id
}