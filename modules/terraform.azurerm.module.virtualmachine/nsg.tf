# module "vm_nsg" {
#   source              = "../ILM-terraform-azurerm-nsg"
#   project             = var.project
#   deployment          = var.deployment
#   resource_group_name = data.azurerm_resource_group.vmrg.name
#   nsg_count           = var.resource_count
#   nsg_name            = "${var.project}-${var.deployment}-vm${length(var.component) > 0 ? "-${var.component}" : ""}-nsg"

#   rule_list = var.vm_nsg_rule
#   tags      = var.tags
# }

# resource "azurerm_network_interface_security_group_association" "vmnsg_association" {
#   count                     = var.resource_count
#   network_interface_id      = azurerm_network_interface.nic[count.index].id
#   network_security_group_id = module.vm_nsg.nsgid[0]
#   depends_on = [
#     azurerm_network_interface.nic,
#     module.vm_nsg
#   ]
# }
