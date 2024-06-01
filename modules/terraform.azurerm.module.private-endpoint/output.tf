// output "private_ip" {
//   value = toset(azurerm_private_endpoint.private_endpoint[*].private_service_connection[0].private_ip_address)
// }

output "private_ip" {
  value = azurerm_private_endpoint.private_endpoint.private_service_connection[*].private_ip_address
}

// output "privateip" {
//   value       = toset(module.pe_batch[*].private_service_connection.0.private_ip_address)
// }

// output "pe_name" {
//   value = azurerm_private_endpoint.private_endpoint.name
// }