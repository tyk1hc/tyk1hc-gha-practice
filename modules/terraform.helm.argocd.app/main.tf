locals {
  #Remove map keys from all_repositories with no value. That means they were not specified
  # clean_source = {
  #   for name, repo in var.source_repo : "${name}" => {
  #     for k, v in repo : k => v if v != null
  #   }
  # }


values = merge( 
  # {
  #   projects = {
  #     destinations = [{
  #                       namespace = var.destination_namespace
  #                       server = "https://kubernetes.default.svc"
  #                   }]
  #   }
  # }
)

}

#ArgoCD Charts
resource "helm_release" "argocd_application_stardog_launchpad" {
  name                = var.helm_release_name
  repository          = "oci://${var.acr}.azurecr.io"
  chart               = "helm/argocd-apps"
  repository_username = var.acr_username
  repository_password = var.acr_pass
  version             = var.chart_version
  namespace           = "${var.env}-${var.namespace}"
  
  values = concat(
    [yamlencode(local.values), yamlencode(var.values)],
    [for x in var.values_files : file(x)]
  )

set {
  name = "applications[0].namespace"
  value = var.argocd_namespace
}

set {
  name = "applications[0].source.repoURL"
  value = var.git_repo_url
}


set {
  name = "applications[0].source.targetRevision"
  value = var.target_revision
}

set {
  name = "applications[0].source.path"
  value = var.gitrepo_path
}

set { 
  name = "applications[0].source.helm.valueFiles[0]"
  value = var.values_file
}

set {
  name = "applications[0].destination.namespace"
  value = var.destination_namespace
}
}