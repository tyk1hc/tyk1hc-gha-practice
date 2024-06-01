#-------------------------------
# Diagnostic Logs
#-------------------------------
# resource "azurerm_monitor_diagnostic_setting" "appgateway_diag" {
#   count                      = var.resource_count
#   name                       = "mondiag-${azurerm_application_gateway.appgw.*.name[count.index]}-${var.service_logging[0]["service"]}"
#   target_resource_id         = azurerm_application_gateway.appgw.*.id[count.index]
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   dynamic "log" {
#     for_each = var.service_logging[0]["logs"]
#     content {
#       category = log.key
#       enabled  = log.value
#       retention_policy {
#         enabled = true
#         days    = var.retention_days
#       }
#     }
#   }

#   dynamic "metric" {
#     for_each = var.service_logging[0]["metrics"]
#     content {
#       category = metric.key
#       enabled  = metric.value
#       retention_policy {
#         enabled = true
#         days    = var.retention_days
#       }
#     }
#   }
#   depends_on = [
#     azurerm_application_gateway.appgw
#   ]
# }