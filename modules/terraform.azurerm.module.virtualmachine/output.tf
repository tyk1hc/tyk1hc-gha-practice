output "id" {
  value = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[*].id : azurerm_linux_virtual_machine.linuxvm[*].id
}

output "private_ip_address" {
  value = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[*].private_ip_address : azurerm_linux_virtual_machine.linuxvm[*].private_ip_address
}