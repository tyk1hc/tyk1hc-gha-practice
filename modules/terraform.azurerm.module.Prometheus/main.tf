
resource "azurerm_resource_group_template_deployment" "arm_template_prometheus" { 
name= var.template_name
resource_group_name =var.rg_name 
deployment_mode  = var.deployment_mode
template_content= <<TEMPLATE
{
    "$schema": "http://schema.management.azure.com/schemas/2014-04-01-preview/deploymentTemplate.json#",
     "contentVersion": "1.0.0.0",
      "resources": [{ "type": "microsoft.monitor/accounts",
      "name": "${var.Prometheous_name}",
      "location": "${var.location}",
      "apiVersion": "2021-06-03-preview"
    }
       
    ]
}
TEMPLATE
}