variable "template_rg_name" {
type = string  
}
variable "template_location" {
type = string  
}
variable "template_deployment_mode" {
type = string  
}
variable "Recording_Rules_enabled" {
  default = ""
}
variable "new_template_name" {
type = string  
}

variable "PrometheusName"{
    type=string
}
variable "ClusterName"{
    type=string
}
variable "GrafanaName"{
    type=string
}
variable "subscriptionId"{
    type=string
}
variable "template_cluster_rg_name" {
type = string  
}