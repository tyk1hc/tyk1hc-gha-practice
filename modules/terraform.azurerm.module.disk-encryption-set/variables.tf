variable "diskencryptionsetname" {
type = string  
}

variable "key_vault_key_id" {
}

variable "key_vault_id" {
}

variable "aks_managed_identity_principal_id" {
}
variable "location" {
  type = string 
}

variable "resource_group_name" {
type = string  
}

variable "tags"{
  type = map(string)
}


