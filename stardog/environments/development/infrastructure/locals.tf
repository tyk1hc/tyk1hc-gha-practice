locals {
    Environment = "${var.ProjectEnvironment[Development]}"
    Project = "${var.ProjectName}"
    Location = "${var.Location}"

    ResourceGroup_VirtualNetwork = "${local.Project}-${var.AzureResourceTypes[ResourceGroup]}-${local.Environment}-${local.Location}"
}