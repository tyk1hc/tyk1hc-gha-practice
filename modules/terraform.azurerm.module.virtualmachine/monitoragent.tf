 resource "azurerm_virtual_machine_extension" "AzureMonitorLinuxAgent" {  
      count                      = var.resource_count      
      name                       = "AzureMonitorLinuxAgent"
      publisher                  = "Microsoft.Azure.Monitor"
      type                       = "AzureMonitorLinuxAgent"
      type_handler_version       = "1.0"
      auto_upgrade_minor_version = "true"
    
      virtual_machine_id = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
    }
     resource "azurerm_monitor_data_collection_rule" "example" {
      name                = "example-rules"
      resource_group_name = var.rg_name
      location            = var.location
    
      destinations {
        log_analytics {
          workspace_resource_id = var.log_analytics_workspace_resource_id
          name                  = "test-destination-log"
        }
    
        azure_monitor_metrics {
          name = "test-destination-metrics"
        }
      } 
    
      data_flow {
        streams      = ["Microsoft-InsightsMetrics"]
        destinations = ["test-destination-log"]
      }
    
      data_sources {
    
        performance_counter {
          streams                       = ["Microsoft-InsightsMetrics"]
          sampling_frequency_in_seconds = 60
          counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
          name                          = "VMInsightsPerfCounters"
        }
    }
     }
    
    # associate to a Data Collection Rule
    resource "azurerm_monitor_data_collection_rule_association" "example1" {
      count                   = var.resource_count
      name                    = "example1-dcra"
      target_resource_id      = var.is_windows_image ? azurerm_windows_virtual_machine.winvm[count.index].id : azurerm_linux_virtual_machine.linuxvm[count.index].id
      data_collection_rule_id = azurerm_monitor_data_collection_rule.example.id
      description             = "example"
    }