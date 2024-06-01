
#Author: Kumar Sathish (SX/BSI4)

#data "azurerm_client_config" "current" {}

# data "azurerm_resource_group" "vmrg" {
#   name = var.rg_name
# }

resource "azurerm_network_interface" "nic" {
  count               = var.resource_count
  #name                = "nic-vm-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
  name                = var.network_interface_name
  resource_group_name = var.rg_name
  location            = var.location
  ip_configuration {
    name                          = "ip-vm-${format("%02d", count.index + 1)}-${var.naming_convention}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address_allocation == "Static" ? var.private_ip_address : null
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.vmpubip[0].id : null
  }
}

data "template_file" "linux-vm-cloud-init" {
  count = var.custom_data != "" ? 1 : 0
  template = file("${path.cwd}/${var.custom_data}")
}

module "additionalmanageddisk" {
  source = "./manageddisks"
  count = length(var.additiontalmanageddisk) > 0 ? var.resource_count : 0
  disks = var.additiontalmanageddisk
  VMIndex = format("%02d", count.index + 1)
  virtual_machine_id   = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
  env = var.env
  projectname = var.projectname
  #location = data.azurerm_resource_group.vmrg.location
  location = var.location
  app = var.app
  rg = var.rg_name
  naming_convention = var.naming_convention
}

module "vmadminlogin_roleassignment" {
  source = "./vmroleassignment"
  count = length(var.vmadminlogin_ids) > 0 ? var.resource_count : 0
  vmadminlogin_ids = var.vmadminlogin_ids
  virtual_machine_id   = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
}

module "vmuserlogin_roleassignment" {
  source = "./vmroleassignment"
  count = length(var.vmuserlogin_ids) > 0 ? var.resource_count : 0
  vmuserlogin_ids = var.vmuserlogin_ids
  virtual_machine_id   = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
}




resource "azurerm_public_ip" "vmpubip" {
  count               = var.public_ip ? var.resource_count : 0
  name                = var.public_ip_name
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.public_ip_sku
  allocation_method   = var.public_ip_sku == "Standard" ? "Static" : var.allocation_method
  zones   = var.public_ip_availability_zone
  tags = merge({ "ResourceName" = "PubIP" }, var.tags, )

}

# resource "azurerm_key_vault_key" "key" {
#   count        = var.resource_count
#   name         = "Encryption-Key-VM-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
#   key_vault_id = var.key_vault_id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts = [
#     "decrypt",
#     "encrypt",
#     "sign",
#     "unwrapKey",
#     "verify",
#     "wrapKey",
#   ]
# }

# resource "azurerm_disk_encryption_set" "diskencset" {
#   count               = var.resource_count
#   name                = var.linux_vm_disk_encryption_set_vm_name
#   resource_group_name = var.rg_name
#   location            = data.azurerm_resource_group.vmrg.location
#   key_vault_key_id    = var.key_vault_key_id


  # dynamic "identity" {
  #   for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
  #   content {
  #     type = var.identity_type
  #   }
  # }

  # dynamic "identity" {
  #   for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
  #   content {
  #     type         = var.identity_type
  #     identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
  #   }
  # }
# }
# resource "azurerm_key_vault_access_policy" "accesspolity-disk" {
#   key_vault_id = var.key_vault_id

#   tenant_id = azurerm_disk_encryption_set.diskencset.0.identity.0.tenant_id
#   object_id = azurerm_disk_encryption_set.diskencset.0.identity.0.principal_id

#   key_permissions = [
#     "Get",
#     "WrapKey",
#     "UnwrapKey"
#   ]
# }

# resource "azurerm_key_vault_access_policy" "policy-user" {
#   key_vault_id = var.key_vault_id

#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = data.azurerm_client_config.current.object_id

#   key_permissions = [
#     "get",
#     "create",
#     "delete"
#   ]
# }

#SSH key creation
# resource "tls_private_key" "linvm_ssh" {
#   count = var.admin_password ? 0 : var.resource_count
#   algorithm   = "RSA"
#   rsa_bits = "2048"
# }

# resource "azurerm_key_vault_secret" "ssh_secret" {
#   count = var.resource_count
#   name         = "Private-Key-VM-${lower(replace("${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}", "/[[:^alnum:]]/", ""))}"
#   value        = var.admin_password ? random_password.vm_pass[count.index].result : tls_private_key.linvm_ssh[count.index].private_key_pem
#   key_vault_id = var.key_vault_id
# }

# resource "random_password" "vm_pass" {
#   count = var.resource_count
#   length           = 8
#   special          = true
#   override_special = "_%@"
# }

resource "azurerm_linux_virtual_machine" "linuxvm" {
  count                 = !contains(tolist([var.vm_os_offer]), "WindowsServer") && !var.is_windows_image ? var.resource_count : 0
  #name                 = "vm-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
  # name                  = "vm-${var.app}-${format("%02d", count.index + 1)}-${var.naming_convention}"
  name                  =   var.linux_vm_name
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = var.enable_admin_password ? false : true
  patch_mode            = "AutomaticByPlatform"
  patch_assessment_mode = "AutomaticByPlatform"
         
  #computer_name         = "${local.compute_name}${format("%02d", count.index + 1)}${local.compute_name_suffix}"
  computer_name         = var.computer_name
  dynamic "admin_ssh_key" {
    for_each = toset(var.enable_admin_password ? [] : [1])
    content {
      username   = var.admin_username
      public_key = var.public_key
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }


  source_image_id = var.image_id

  dynamic "source_image_reference" {
    for_each = var.image_id == null ? [1] : []
    content {
      publisher = var.vm_os_publisher
      offer     = var.vm_os_offer
      sku       = var.vm_os_sku
      version   = var.vm_os_version
    }
  }

  os_disk {
    #name                   = "OSDisk-VM-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
    # name                   = "osdisk-vm-${var.app}-${format("%02d", count.index + 1)}-${var.naming_convention}"
    name                   =   var.disk_name
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type
    #disk_encryption_set_id = var.key_vault_key_id != null ? azurerm_disk_encryption_set.diskencset[count.index].id : null
    disk_size_gb           = var.os_disk_size
    
  }

  tags = merge({ "ResourceName" = "LinuxVM" }, var.tags, )

  boot_diagnostics {
    storage_account_uri = "${var.boot_diagnostics_sa}"

  }
  custom_data = var.custom_data != "" ? base64encode("${element(data.template_file.linux-vm-cloud-init.*.rendered, 0 )}") : null

  lifecycle {
    ignore_changes = [custom_data,os_disk,bypass_platform_safety_checks_on_user_schedule_enabled,identity]
  }

}

resource "azurerm_virtual_machine_extension" "disk_encryption" {
  count                      = var.disk_encryption_enabled ? 1 : 0
  name                       = "disk-encryption"
  virtual_machine_id         = azurerm_linux_virtual_machine.linuxvm[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryptionForLinux"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = "true"

  settings = <<SETTINGS
{
  "EncryptionOperation": "EnableEncryption",
  "KeyVaultURL": "https://${var.vaultname}.vault.azure.net",
  "KeyVaultResourceId": "${var.subscriptionid}/resourceGroups/${var.manual_rg_name}/providers/Microsoft.KeyVault/vaults/${var.vaultname}",
  "KeyEncryptionAlgorithm": "RSA-OAEP",
  "VolumeType": "All",
  "KeyEncryptionKeyURL": "https://${var.vaultname}.vault.azure.net/keys/${var.keyname}/${var.keyversion}",
  "KekVaultResourceId": "${var.subscriptionid}/resourceGroups/${var.manual_rg_name}/providers/Microsoft.KeyVault/vaults/${var.vaultname}"
}
SETTINGS

}

resource "azurerm_windows_virtual_machine" "winvm" {
  count                 = contains(tolist([var.vm_os_offer]), "WindowsServer") && var.is_windows_image ? var.resource_count : 0
  #name                  = "VM-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
  name                  = "vm-${format("%02d", count.index + 1)}-${var.naming_convention}"
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  computer_name         = "${local.compute_name}${format("%02d", count.index + 1)}${var.env}"

  os_disk {
    #name                   = "OSDisk-VM-${length(var.component) > 0 ? "-${var.component}" : ""}-${format("%02d", count.index + 1)}-${var.naming_convention}"
    name                   = "osdisk-vm-${var.app}-${format("%02d", count.index + 1)}-${var.naming_convention}"
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type
    #disk_encryption_set_id = var.key_vault_id != null ? azurerm_disk_encryption_set.diskencset[count.index].id : null
    disk_size_gb           = var.os_disk_size
  }

  source_image_id = var.image_id

  dynamic "source_image_reference" {
    for_each = var.image_id == null ? [1] : []
    content {
      publisher = var.vm_os_publisher
      offer     = var.vm_os_offer
      sku       = var.vm_os_sku
      version   = var.vm_os_version
    }
  }
  
  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  tags = merge({ "ResourceName" = "WindowsVM" }, var.tags, )

  boot_diagnostics {
    storage_account_uri = "${var.boot_diagnostics_sa}"

  }
}


