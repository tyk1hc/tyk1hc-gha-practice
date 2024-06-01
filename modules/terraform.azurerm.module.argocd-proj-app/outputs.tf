output "namespace" {
  description = "the kubernetes namespace of the release"
  value       = helm_release.argocd_application.namespace
}

output "release_name" {
  description = "the name of the release"
  value       = helm_release.argocd_application.name
}
# output "kube_config" {
#   value = data.azurerm_kubernetes_cluster.example.kube_admin_config_raw
#   sensitive = true
# }