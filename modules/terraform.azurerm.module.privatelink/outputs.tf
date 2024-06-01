output "alias" {
  value       = azurerm_private_link_service.pvs.alias
  description = "A globally unique DNS Name for your Private Link Service. You can use this alias to request a connection to your Private Link Service."
}