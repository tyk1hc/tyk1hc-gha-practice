locals {
  #Remove map keys from all_repositories with no value. That means they were not specified
  # clean_repositories = {
  #   for name, repo in var.repositories : "${name}" => {
  #     for k, v in repo : k => v if v != null
  #   }
  # }


  values = merge(
    {
    env                   = var.env
    keyvault_env          = var.keyvault_env    
    userAssignedIdenttyID = var.userAssignedIdenttyID
    rbac                  = var.rbac_config
    
      global = {
      image = {
        tag = var.image_tag
      }
    }
     server = {
      config     = var.config
      rbacConfig = var.rbac_config
      # Run insecure mode if specified, to prevent argocd from using it's own certificate
      extraArgs = var.server_insecure ? ["--insecure"] : null
      # Ingress Values
      ingress = {
        hosts       = [var.ingress_host]
        tls = var.server_insecure ? [{
          secretName = var.ingress_tls_secret
          hosts      = [var.ingress_host]
        }] : null
      }
    }
     configs = {
       # Configmaps require strings, yamlencode the map
      #repositories = local.clean_repositories
      secret = {
        extra = var.client_secret_id
      }
      cm ={
        url  = "https://${var.ingress_host}/"
      }

    #   repositories = {
    #     private-repo= {
    #       url = var.git_repo
    #       username = var.git_username
    #       project = var.application_project
    #       password = var.gitrepo_token
    #     }
    #  }
   }
  }
)

}

#ArgoCD Charts
resource "helm_release" "argocd" {
  name                = "argocd"
  repository          = "oci://${var.acr}.azurecr.io"
  chart               = "helm/argo-cd"
  repository_username = var.acr_username
  repository_password = var.acr_pass
  version             = var.chart_version
  namespace           = "${var.env}-${var.namespace}"
  create_namespace    = var.create_namespace
  # force_update = true
  # dependency_update = true

  values = concat(
    [yamlencode(local.values), yamlencode(var.values)],
    [for x in var.values_files : file(x)]
  )

set {
  name = "configs.repositories.private-repo.url"
  value = var.git_repo
}

set {
  name = "configs.repositories.private-repo.username"
  value = var.git_username
}

set {
  name = "configs.repositories.private-repo.project"
  value = var.application_project
}

set {
  name = "configs.repositories.private-repo.password"
  value = var.gitrepo_token
}
}


