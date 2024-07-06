resource "azurerm_user_assigned_identity" "aks_user_managed_identity" {
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
  location            = local.Location
  name                = "${local.Project}-user-managed-identity-aks"
}

resource "azurerm_role_assignment" "aks_managed_identity_role_assignment_aks_rg" {
  scope                = azurerm_resource_group.resource-group-virtual-network.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_user_managed_identity.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
    name = "${local.Project}-${var.AzureResourceTypes["AzureKubernetes"]}-aks-test-${local.Environment}"
    location = azurerm_resource_group.resource-group-virtual-network.location
    resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
    dns_prefix = "devaks1"

    kubernetes_version = "1.28.9"
    automatic_channel_upgrade = "stable"
    private_cluster_enabled = false 
    node_resource_group = "${local.Project}-${var.AzureResourceTypes["ResourceGroup"]}-aks-nodes-${local.Environment}"

    sku_tier = "Free"

    oidc_issuer_enabled = true
    workload_identity_enabled = true 

    network_profile {
      network_plugin = "azure"
      dns_service_ip = "10.96.1.10"
      service_cidr = "10.96.0.0/12"
    }

    default_node_pool {
      name = "general"
      vm_size = "Standard_D2_v2"
      vnet_subnet_id = module.azure_virtual_network.subnets_map[local.Subnet_AKS]
      orchestrator_version = "1.28.9"
      type = "VirtualMachineScaleSets"
      enable_auto_scaling = true 
      node_count = 1
      min_count = 1
      max_count = 3

      node_labels =  {
        role = "general"
      }
    }

    identity {
      type = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.aks_user_managed_identity.id]
    }

    tags = {
        Environment = "Development"
    }

    lifecycle {
      ignore_changes = [ default_node_pool[0].node_count ]
    }

    depends_on = [ azurerm_role_assignment.aks_managed_identity_role_assignment_aks_rg ]

}




resource "azurerm_kubernetes_cluster_node_pool" "spot" {
    name                  = "spot"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
    vm_size               = "Standard_DS2_v2"
    vnet_subnet_id        = azurerm_subnet.subnet1.id
    orchestrator_version  = "1.28.9"
    priority              = "Spot"
    spot_max_price        = -1
    eviction_policy       = "Delete"

    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 10

    node_labels = {
        role                                    = "spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
    }

    node_taints = [
        "spot:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
    ]

    tags = {
        Environment = "Development"
    }

    lifecycle {
        ignore_changes = [node_count]
    }
}