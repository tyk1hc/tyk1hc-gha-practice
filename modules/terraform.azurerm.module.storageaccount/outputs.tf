# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt


output "id" {
  description = "The resource id"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "tags" {
  value = azurerm_storage_account.storage_account.tags
}

output "primary_location" {
  description = "The primary location of the storage account."
  value       = azurerm_storage_account.storage_account.primary_location
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account."
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  description = "The primary queue endpoint of the storage account."
  value       = azurerm_storage_account.storage_account.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "The primary table endpoint of the storage account."
  value       = azurerm_storage_account.storage_account.primary_table_endpoint
}

output "primary_file_endpoint" {
  description = "The primary file endpoint of the storage account."
  value       = azurerm_storage_account.storage_account.primary_file_endpoint
}

output "primary_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the storage account."
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
}

output "primary_blob_connection_string" {
  description = "The primary blob connection string for the storage account."
  value       = azurerm_storage_account.storage_account.primary_blob_connection_string
}

output "identity" {
  description = "The identity information for the storage account."
  value       = azurerm_storage_account.storage_account.identity
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_storage_account.storage_account.resource_group_name
}

output "aatp_id" {
  description = "Resource Group Name"
  value       = azurerm_advanced_threat_protection.threat_protection.*.id
}