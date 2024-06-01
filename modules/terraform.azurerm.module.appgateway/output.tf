# output "ip_address" {
#   value = azurerm_public_ip.ip.ip_address
# }

output "app_gw_id" {
  value = flatten([azurerm_application_gateway.appgw.*.id])
}