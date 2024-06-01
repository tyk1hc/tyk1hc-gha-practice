variable "projectname" {
  default="stardog"
}
variable "location" {}
variable "env" {
 default="dev" 
}
variable "app" {
  default="st"
}
variable "naming_convention" {
  default="stardog-dev"
}
variable "tags" {}

variable "component" {
  description = "component type"
  type        = string
  default     = "vm"
}
variable "linux_vm_name" {
  type        = string
}
variable "computer_name" {
  type        = string
}
variable "disk_name"{
  type = string
}

variable "resource_count" {
  description = "total number of resources"
  default     = 1
}

variable "rg_name" {
  description = "Resource group name to deploy the VM"
}

variable "manual_rg_name" {
  description = "Resource group name to deploy the VM"
}
# variable "additiontalmanageddisk" {
#     type =  list(object({
#             disk_name = string
#             storage_account_type = string
#             disk_size_gb         = number
#             creation_option = string
#             source_id_uri = string
#         }))
# }


variable "additiontalmanageddisk" {
  description = "Virtual Machines"
  type = map
  default = {}
}

variable "subnet_id" {

}

variable "key_vault_id" {
  default = ""
}

variable "vm_size" {
  description = "Size of the Azure VM"
  default     = "Standard_F2"
}

variable "admin_user" {
  description = "Admin User name to login to the VM"
  type        = string
  default     = "adminuser"
}


variable "admin_password" {
  description = "Admin User password to login to the VM, Ignored when Public key mentioned for Linux Machine"
  type        = string
  default     = null
}

variable "enable_admin_password" {
  type        = string
  default     = null
}


# variable "admin_password" {
#     type        = string
# }


variable "public_key" {
  description = "Admin User SSH public key filename, Ignored when OS type is Windows and If password is mentioned"
  type        = string
  default     = ""
}


variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}

variable "vmadminlogin_ids" {
  description = "Specifies a list of user/group id's need login access to the VM."
  type        = list(string)
  default     = []
}

variable "vmuserlogin_ids" {
  description = "Specifies a list of user/group id's need login access to the VM."
  type        = list(string)
  default     = []
}

variable "identity_type" {
  description = "The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = "SystemAssigned"
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based."
  type        = bool
  default     = false
}


variable "image_id" {
    type        = string
    default     = null
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy."
  type        = string
  default     = "UbuntuServer"
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = "Canonical"
}


variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id are provided."
  type        = string
  default     = "16.04-LTS"
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id are provided."
  type        = string
  default     = "latest"
}

variable "os_disk_size" {
  default = 50
}
variable "storage_account_type" {
  default = "Standard_LRS"
}

variable "boot_diagnostics_sa" {
  default = ""
}

variable "vaultname" {
  default = ""
}

variable "disk_encryption_enabled" {
  default = "true"
}


variable "subscriptionid" {
  default = ""
}


variable "keyname" {
  default = ""
}

variable "keyversion" {
  default = ""
}
variable "diagnostics_sa" {
  type = string
  default = ""
}

variable "linux_vm_disk_encryption_set_vm_name" {
  type = string
  default = ""
}

variable "key_vault_key_id" {
  type = string
  default = ""
}

variable "diagnostics_sa_connstr" {
  type = string
  default = ""
}
variable "public_ip_name" {
  type = string
  default = ""
}
variable "public_ip" {
  type    = bool
  default = false
}


variable "public_ip_availability_zone" {
  type = list(string)
  default = []
}

variable "public_ip_sku" {
  default = "Standard"
}

variable "allocation_method" {
  default = ""
}

variable "log_analytics_workspace_id" {

}

variable "log_analytics_workspace_resource_id" {

}
variable "azurerm_log_analytics_workspace_key" {

}
variable "network_interface_name"{
  type=string
}


variable "admin_username" {
  type = string
}

variable "vm_nsg_rule" {
  type = any
  default = []
}


variable "private_ip_address_allocation" {
    type = string
    default = "Dynamic"
}

variable "custom_data" {
    type = string
    default = ""
}

variable "private_ip_address" {
    type = string
    default = ""
}
