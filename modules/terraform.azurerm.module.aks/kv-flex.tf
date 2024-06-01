# Copyright (c) 2009, 2019 Robert Bosch GmbH and its subsidiaries.
# This program and the accompanying materials are made available under
# the terms of the Bosch Internal Open Source License v4
# which accompanies this distribution, and is available at
# http://bios.intranet.bosch.com/bioslv4.txt

locals {
  kvcreds_count = var.kvcreds != null ? 1 : 0
}

data "azurerm_client_config" "current" {
  count = local.kvcreds_count
}

data "azurerm_key_vault" "keyvault-flex" {
  count               = local.kvcreds_count
  name                = var.kvcreds.keyvault_name
  resource_group_name = var.kvcreds.keyvault_rg
}

resource "kubernetes_secret" "aks_kv_sp_creds" {
  depends_on = [azurerm_kubernetes_cluster.kubernetes_cluster]

  for_each = local.kvcreds_count == 1 ? var.kvcreds.namespaces : toset([])

  metadata {
    name      = "kvcreds"
    namespace = each.value
  }

  data = {
    clientid     = azuread_application.aks_kv_app[0].application_id
    clientsecret = azuread_service_principal_password.aks_kv_sp_password[0].value
  }

  type = "azure/kv"
}

resource "azuread_application" "aks_kv_app" {
  count = local.kvcreds_count

  display_name = "${var.name}-kv"
  owners       = [data.azurerm_client_config.current[0].object_id]
}

resource "azuread_service_principal" "aks_kv_sp" {
  count = local.kvcreds_count

  application_id = azuread_application.aks_kv_app[0].application_id
  owners         = [data.azurerm_client_config.current[0].object_id]
}

resource "time_rotating" "aks_kv_sp_password" {
  count         = local.kvcreds_count
  rotation_days = 548
}

resource "azuread_service_principal_password" "aks_kv_sp_password" {
  count = local.kvcreds_count

  service_principal_id = azuread_service_principal.aks_kv_sp[0].id
  rotate_when_changed = {
    rotation = time_rotating.aks_kv_sp_password[0].id
  }
}

resource "azurerm_role_assignment" "aks_kv_ra_reader" {
  count = local.kvcreds_count

  scope                = data.azurerm_key_vault.keyvault-flex[0].id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.aks_kv_sp[0].id
}

resource "azurerm_key_vault_access_policy" "kv_sp" {
  count = local.kvcreds_count

  key_vault_id = data.azurerm_key_vault.keyvault-flex[0].id

  tenant_id = data.azurerm_client_config.current[0].tenant_id
  object_id = azuread_service_principal.aks_kv_sp[0].id

  key_permissions         = ["Get"]
  secret_permissions      = ["Get"]
  certificate_permissions = ["Get"]
}
