#Contains variable declarations
variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "RG location in Azure"
}

variable "resource_environment_tags" {
  type = map(string)
  default = {
    development = "Dev"
    quality = "QA"
    production = "Pro"
  }
}