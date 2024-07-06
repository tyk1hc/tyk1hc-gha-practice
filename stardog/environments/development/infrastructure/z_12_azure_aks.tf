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
    vnet_subnet_id        = module.azure_virtual_network.subnets_map[local.Subnet_AKS]
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

data "azurerm_kubernetes_cluster" "this" {
    name = "${local.Project}-${var.AzureResourceTypes["AzureKubernetes"]}-aks-test-${local.Environment}"
    resource_group_name = azurerm_resource_group.resource-group-virtual-network.name

    depends_on = [ azurerm_kubernetes_cluster.this ]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "external_nginx" {
  name = "external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = "4.8.0"

  values = [file("${path.module}/values/ingress.yaml")]
}

resource "helm_release" "cert_manager" {
    name = "cert-manager"

    repository = "https://charts.jetstack.io"
    chart = "cert-manager"
    namespace = "cert-manager"
    create_namespace = true 
    version = "v1.13.1"

    set {
        name  = "installCRDs"
        value = "true"
    }
}

#Workload Managed Identity
resource "azurerm_user_assigned_identity" "dev_test" {
    name = "dev-test"
    location = azurerm_resource_group.resource-group-virtual-network.location
    resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
}

resource "azurerm_federated_identity_credential" "dev_test" {
  name                = "dev-test"
  resource_group_name = azurerm_resource_group.resource-group-virtual-network.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.dev_test.id
  subject             = "system:serviceaccount:dev:my-account"

  depends_on = [azurerm_kubernetes_cluster.this]
}

#Storage Account
resource "random_integer" "this" {
  min = 10000
  max = 5000000
}

resource "azurerm_storage_account" "this" {
  name                     = "devtest${random_integer.this.result}"
  resource_group_name      = azurerm_resource_group.resource-group-virtual-network.name
  location                 = azurerm_resource_group.resource-group-virtual-network.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = "test"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "dev_test" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.dev_test.principal_id
}