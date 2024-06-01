


resource "azurerm_virtual_machine_extension" "vmextguest" {
  count = var.resource_count
  name                       = "GuestConfiguration"
  virtual_machine_id         = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = var.is_windows_image ? "ConfigurationforWindows" : "ConfigurationforLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  tags                       = var.tags
}
# resource "azurerm_virtual_machine_extension" "Site24x7LinuxServerAgent" {
#   count = var.resource_count
#   name                 = "Site24x7LinuxServerAgent"
#   virtual_machine_id   = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
#   publisher            = "Site24x7"
#   type                 = var.is_windows_image ? "MicrosoftMonitoringAgent" : "Site24x7LinuxServerExtn"
#   type_handler_version = "1.0"
#   tags                 = var.tags
#   settings             = <<SETTINGS
#         {
#           "site24x7AgentType": "azurevmextnlinuxserver"
#         }        
#         SETTINGS
#   protected_settings   = <<PROTECTED_SETTINGS
#         {
#             "site24x7LicenseKey": "${var.azurerm_log_analytics_workspace_key}"
#         }
#         PROTECTED_SETTINGS
# }


data "template_file" "diag_json_config" {
  template = file("${path.module}/linux_diagnostic.json")

  vars = {
    vm_id            = "${var.is_windows_image ? azurerm_windows_virtual_machine.winvm[0].id : azurerm_linux_virtual_machine.linuxvm[0].id}"
    storage_account  = var.diagnostics_sa
  }
}

# resource "azurerm_virtual_machine_extension" "vmextaadlogin" {
#   count = var.resource_count
#   name                       = "AADLogin"
#   virtual_machine_id         = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
#   publisher                  = "Microsoft.Azure.ActiveDirectory"
#   type                       = "AADSSHLoginForLinux"
#   type_handler_version       = "1.0"
#   auto_upgrade_minor_version = true
#   depends_on = [
#     azurerm_linux_virtual_machine.linuxvm
#   ]
# }

# data "azurerm_storage_account_sas" "diagsas" {
#   connection_string = var.diagnostics_sa_connstr
#   https_only        = true
#   signed_version    = "2017-07-29"

#   resource_types {
#     service   = false
#     container = true
#     object    = true
#   }

#   services {
#     blob  = true
#     queue = false
#     table = true
#     file  = false
#   }

#   start  = "2022-01-01T00:00:00Z"
#   expiry = "2027-12-31T00:00:00Z"

#   permissions {
#     read    = true
#     write   = true
#     delete  = false
#     list    = true
#     add     = true
#     create  = true
#     update  = true
#     process = false
#   }
# }

# resource "azurerm_virtual_machine_extension" "linuxdiag" {
#   name                 = "LinuxDiagnostic"
#   virtual_machine_id   = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[0].id : azurerm_linux_virtual_machine.linuxvm[0].id
#   publisher            = "Microsoft.Azure.Diagnostics"
#   type                 = var.is_windows_image ? "MicrosoftMonitoringAgent" : "LinuxDiagnostic"
#   type_handler_version = "4.0"
#   tags                 = var.tags
#   settings = data.template_file.diag_json_config.rendered
#   protected_settings   = <<PROTECTED_SETTINGS
#     {
#         "storageAccountName": "${var.diagnostics_sa}",
#         "storageAccountSasToken": "${data.azurerm_storage_account_sas.diagsas.sas}"
#     }
#         PROTECTED_SETTINGS
# }