# variable "disks" {
#     type =  list(object({
#             disk_name = string
#             storage_account_type = string
#             disk_size_gb         = number
#             creation_option = string
#             source_id_uri = string
#         }))
# }


variable "disks" {
  description = "Virtual Machines"
  type = map
}

variable "projectname" {}
variable "location" {}
variable "env" {}
variable "virtual_machine_id" {}
variable "VMIndex" {}
variable "rg" {}
variable "app" {}
variable "naming_convention" {}