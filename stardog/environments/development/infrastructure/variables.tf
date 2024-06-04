# Project  Name
variable "ProjectName" {
  type        = string
  default     = "ttky"
  description = "Project Name"
}

# Environment
variable "ProjectEnvironment" {
  type = map(string)
  default = {
    "Development" = "dev",
    "Quality"     = "qa",
    "Production"  = "pro"
  }
  description = "Environment value"
}

# Location
variable "Location" {
  type        = string
  default     = "southeastasia"
  description = "The Azure Region in which all resources should be provisioned"
}


# --- Azure Resource Types ---
variable "AzureResourceTypes" {
  type = map(string)
  default = {
    ResourceGroup  = "rg"
    VirtualNetwork = "vnet"
    LogAnalyticWorkSpace = "log"
    NetworkSecurityGroup = "nsg"
    ContainerRegistry = "cr"
  }
  description = "The Azure Resource Group Type Abbreviation"
}

# --- Azure Virtual Network ---
variable "vnet_default_address_spaces" {
  type = string
  default = "10.0.0.0/16"
  description = "The default virtual network address spaces"
}

variable "subnet_common_address_spaces" {
  type = string
  default = "10.0.1.0/24"
  description = "The common address spaces"
}

variable "subnet_app_gateway_address_spaces" {
  type = string
  default = "10.0.2.0/24"
  description = "The application gateway address spaces"
}

variable "subnet_aks_address_spaces" {
  type = string
  default = "10.0.192.0/18"
  description = "The AKS address spaces"
}