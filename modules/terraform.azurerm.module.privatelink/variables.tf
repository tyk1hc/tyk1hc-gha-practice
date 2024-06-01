
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the private link service."
}

variable "resource_group_name_location" {
  type        = string
  description = "The location/region where the private link service is created."
}

variable "auto_approval_subscription_ids" {
  type        = list(string)
  default     = null
}

variable "visibility_subscription_ids" {
  type        = list(string)
  default     = null
}
variable "azurerm_private_link_service_name" {
  type        = string

}

variable "load_balancer_frontend_ip_configuration_ids" {
  type        = list(string)
  default     = null
}


variable "primary_nat_ip_name" {
  type        = string
  default     = null
}
variable "location" {
  type        = string
}

variable "private_ip_address" {
  type        = string
  default     = null
}

variable "aks_subnet_id" {
  type        = string
  default     = null
}
