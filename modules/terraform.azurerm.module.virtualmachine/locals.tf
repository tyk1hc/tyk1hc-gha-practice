locals {
  # Local variables for resource tags
  # tag_creator                  = "terraform"
  # append_id                    = false
  # tag_tf_version               = var.tf_version
  # tag_azurerm_provider_version = var.tf_azurerm_version
  # project_tags = {
  #   creator            = local.tag_creator
  #   tf-version         = local.tag_tf_version
  #   tf-azurerm-version = local.tag_azurerm_provider_version
  #   env                = var.env
  #   department     = "pog2"
  #   component = "infra"
  # }

  # naming_convention = "${var.projectname}-${var.location}-${var.env}"
  # app_naming_convention = "${var.app}${var.location}-${var.env}"
  #public_cloud      = split("_", data.azurerm_subscription.current.location_placement_id)[0] == "Public" ? true : false
  compute_name = replace("vm${var.app}", "-", "")
  compute_name_suffix = replace("${var.naming_convention}", "-", "")
  
}