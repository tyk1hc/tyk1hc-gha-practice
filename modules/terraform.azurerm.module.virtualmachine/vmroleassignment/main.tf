# resource "azurerm_role_assignment" "vm_admin_login" {
#   count          = length(var.vmadminlogin_ids)
#   scope          = var.virtual_machine_id
#   role_definition_name = "Virtual Machine Administrator Login"
#   principal_id    = var.vmadminlogin_ids[count.index]
# }

# resource "azurerm_role_assignment" "vm_user_login" {
#   count          = length(var.vmuserlogin_ids)
#   scope          = var.virtual_machine_id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id    = var.vmuserlogin_ids[count.index]
# }