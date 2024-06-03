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
  Subnet_Common = "common-subnet"
  Subnet_AppGateway = "appGateway-subnet"
  Subnet_AKS = "AKS-subnet"

  VirtualNetwork_Subnets = {

    # Common
    common_subnet = {
        subnet_name = local.Subnet_Common, subnet_cidr = ["${var.subnet_common_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }

    # Application Gateway
    appGateway_subnet = {
        subnet_name = local.Subnet_AppGateway, subnet_cidr = ["${var.subnet_app_gateway_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }

    # AKS
    aks_subnet = {
        subnet_name = local.Subnet_AKS, subnet_cidr = ["${var.subnet_aks_address_spaces}"], service_endpoint = ["Microsoft.Storage"]
        delegation_name = "", delegation_service = "", delegation_actions = []
    }
  }



}
