# Project  Name
variable "ProjectName" {
  type = string
  default = "ttky"
  description = "Project Name"
}

# Environment
variable "ProjectEnvironment" {
  type = map(string)
  default = {
    "Development" = "dev",
    "Quality" = "qa",
    "Production" = "pro"
  }
  description = "Environment value"
}

# Location
variable "Location" {
  type = string
  default     = "southeastasia"
  description = "The Azure Region in which all resources should be provisioned"
}


# --- Azure Resource Types ---
variable "AzureResourceTypes" {
  type = map(string)
  default = {
    ResourceGroup = "rg"
    VirtualNetwork = "vn"
  }
  description = "The Azure Resource Group Type Abbreviation"
}

