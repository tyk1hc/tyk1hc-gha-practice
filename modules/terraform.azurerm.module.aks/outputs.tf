# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

output "kube_admin_config_host" {
  value = length(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config) > 0 ? azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].host : ""
}

output "kube_admin_config_client_certificate" {
  value = length(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config) > 0 ? base64decode(
    azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].client_certificate,
  ) : ""
}

output "kube_admin_config_client_key" {
  value = length(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config) > 0 ? base64decode(
    azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].client_key,
  ) : ""
}

output "kube_admin_config_cluster_ca_certificate" {
  value = length(azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config) > 0 ? base64decode(
    azurerm_kubernetes_cluster.kubernetes_cluster.kube_admin_config[0].cluster_ca_certificate,
  ) : ""
}

output "userAssignedIdenttyID" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.key_vault_secrets_provider.0.secret_identity.0.client_id
}

output "managed_identity_principal_id" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.kubelet_identity[0].object_id
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.id
}
output "node_resource_group" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.node_resource_group
}

output "kubernetes_cluster_fqdn" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.fqdn
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.name
}

output "kubernetes_ingress_application_gateway_identity" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
