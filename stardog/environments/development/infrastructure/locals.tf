locals {
  Environment = var.ProjectEnvironment["Development"]
  Project     = var.ProjectName
  Location    = var.Location

  # Resource Group
  ResourceGroup_Default_Name = "${local.Project}-${var.AzureResourceTypes["ResourceGroup"]}-${local.Environment}-${local.Location}"
  # Log Analytics Workspace
  LogAnalyticWorkSpace_Name = "${local.Project}-${var.AzureResourceTypes["LogAnalyticWorkSpace"]}-${local.Environment}-${local.Location}"
  # Virtual Network
  VirtualNetwork_Name = "${local.Project}-${var.AzureResourceTypes["VirtualNetwork"]}-${local.Environment}-${local.Location}"
  VirtualNetwork_Diag_Name = "${local.VirtualNetwork_Name}_diag"

  # Subnets
  VirtualNetwork_Subnets = {

    # Common
    common_subnet = {
        subnet_name = "common-subnet", subnet_cidr = ["${var.subnet_common_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }

    # Application Gateway
    common_subnet = {
        subnet_name = "appGateway-subnet", subnet_cidr = ["${var.subnet_app_gateway_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }

    # AKS
    common_subnet = {
        subnet_name = "AKS-subnet", subnet_cidr = ["${var.subnet_aks_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }
  }
}
