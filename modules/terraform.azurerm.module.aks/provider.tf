terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">1.6.2,<3"
    }
    time = {
      source  = "hashicorp/time"
      version = "<1"
    }
  }
}