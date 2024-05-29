terraform {
    backend "azurerm" {
        resource_group_name  = "rg-tf-state-learning"
        storage_account_name = "storagetfstatelearning"
        container_name       = "tfstatelearning"
        key                  = "tflearning.tfstate"
        use_oidc             = true
        client_id            = "8e17bdf2-ba07-43db-b223-ba6d7005f6ad"
        subscription_id      = "867cdad6-e31e-43db-94a0-ea0457112ddc"
        tenant_id            = "0ae51e19-07c8-4e4b-bb6d-648ee58410f4"
    }
}