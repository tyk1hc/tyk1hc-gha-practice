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

variable "chart_version" {
  description = "version of charts"
  default     = "5.6.0"
}

variable "helm_release_name" {
  description = "release name"
  default     = ""
}

variable "enable_project" {
  default     = "true"
  type        = bool
}

variable "argocd_namespace" {
  default     = ""
}

variable "project_argocd_namespace" {
  default     = ""
}
variable "git_repo_url" {
  default     = ""
}

variable "project_git_repo_url" {
  default     = ""
}

variable "target_revision" {
  default     = ""
}
variable "gitrepo_path" {
  default     = ""
}

variable "destination_namespace" {
  default     = ""
}

variable "values_file" {
  default     = ""
}

variable "project_destination_server" {
  default     = ""
}

variable "application_destination_server" {
  default     = ""
}

variable "project_destination_namespace" {
  default     = ""
}
variable "stardog_namespace" {
  default     = ""
}
variable "manifests" {
  description = "Raw manifests to be applied after argocd is deployed"
  default     = []
  type        = list(string)
}

variable "manifests_directory" {
  description = "Path/URL to directory that contains manifest files to be applied after argocd is deployed"
  default     = ""
  type        = string
}

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


variable "source_repo" {
  description = "A list of repository defintions"
  default     = {}
  type = map(object({
    repoURL           = string
    targetRevision          = optional(string)
    path      = optional(string)
  }))
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
