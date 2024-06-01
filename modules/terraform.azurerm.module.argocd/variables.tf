variable "namespace" {
  default     = "argocd"
  description = "The namespace to deploy argocd into"
}

variable "create_namespace" {
  default = false
}
variable "env" {
  default     = "dev"
  description = "The env to deploy the argocd"

}
# variable "kube_host" {}
# variable "kube_ca_cert" {}
variable "acr" {}
variable "acr_pass" {}
variable "acr_username" {}
variable "userAssignedIdenttyID" {}
variable "keyvault_env" {}
variable "repositories" {
  description = "A list of repository defintions"
  default     = {}
  type = map(object({
    url           = string
    type          = optional(string)
    username      = optional(string)
    password      = optional(string)
    project       = optional(string)
    sshPrivateKey = optional(string)
  }))
}

variable "chart_version" {
  description = "version of charts"
  default     = "5.6.0"
}

variable "server_extra_args" {
  description = "Extra arguments passed to argoCD server"
  default     = []
}

variable "server_insecure" {
  description = "Whether to run the argocd-server with --insecure flag. Useful when disabling argocd-server tls default protocols to provide your certificates"
  default     = true
}

variable "git_repo" {
  default     = ""
}

variable "git_username" {
  default     = ""
}

variable "application_project" {
  default     = ""
}

variable "gitrepo_token" {
  default     = ""
}

variable "ingress_tls_secret" {
  description = "The TLS secret name for argocd ingress"
  default     = "argocd-tls"
}

variable "ingress_host" {
  description = "The ingress host"
  default     = "tfargocd.1d1816b4cb96427aa853.westeurope.aksapp.io"
}

variable "ingress_annotations" {
  description = "annotations to pass to the ingress"
  default = {
    "kubernetes.io/ingress.class"              = "azure/application-gateway"
    "appgw.ingress.kubernetes.io/ssl-redirect" = "true"
  }
}

variable "client_secret_id" {
  description = "oidc client_secret"
  default = {
    "oidc.secret"  = "value"
  }
}

variable "oidc_config" {
  default     = {}
  description = "Additional oidc config to be added to the Argocd rbac configmap"
}

# variable "manifests" {
#   description = "Raw manifests to be applied after argocd is deployed"
#   default     = []
#   type        = list(string)
# }

# variable "manifests_directory" {
#   description = "Path/URL to directory that contains manifest files to be applied after argocd is deployed"
#   default     = ""
#   type        = string
# }

variable "kube_config" {
  default = "" #file("~/.kube/config")
}

variable "image_tag" {
  description = "Image tag to install"
  default     = null
  type        = string
}

variable "config" {
  default     = {}
  description = "Additional config to be added to the Argocd configmap"
}

variable "rbac_config" {
  default     = {}
  description = "Additional rbac config to be added to the Argocd rbac configmap"
}

variable "values" {
  default     = {}
  description = "A terraform map of extra values to pass to the Argocd Helm"
}

variable "values_files" {
  type        = list(string)
  default     = []
  description = "Path to values files be passed to the Argocd Helm Deployment"
}
