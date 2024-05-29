terraform {
    backend "azurerm" {
        resource_group_name  = "rg-tf-state-learning"
        storage_account_name = "storagetfstatelearning"
        container_name       = "tfstatelearning"
        key                  = "tflearning.tfstate"
    }
}