

output "id" {
  value = azurerm_disk_encryption_set.diskencrypt.id
}

output "principal_id" {
  value = azurerm_disk_encryption_set.diskencrypt.identity.0.principal_id
}


