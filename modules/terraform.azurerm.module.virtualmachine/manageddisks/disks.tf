resource "azurerm_managed_disk" "additional_managed_disk" {
  #for_each             = {for disk in var.disks:  disk.disk_name => disk}
#   for_each   = {
#     for index, disk in var.disks:
#     disk.disk_name => disk
#   }
  for_each = var.disks
  # name                 = "ManagedDisk-${each.value.disk_name}-VM-${var.app}-${var.VMIndex}-${var.naming_convention}"
  name                 = "ManagedDisk-${each.value.disk_name}-VM-${var.VMIndex}-${var.naming_convention}"
  #name                = "ManagedDisk01-VM-${local.db_naming_convention}"
  location             = var.location
  resource_group_name  = var.rg
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  source_uri           = each.value.create_option == "Import" ? each.value.source_id_uri : null
  source_resource_id   = each.value.create_option == "Restore" || each.value.create_option == "Copy" ? each.value.source_id_uri  : null
  image_reference_id   = each.value.create_option == "FromImage" ? each.value.source_id_uri : null
}

resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attachment" {
  count              = length(var.disks)
  managed_disk_id    = azurerm_managed_disk.additional_managed_disk["disk${count.index+1}"].id
  virtual_machine_id   = var.virtual_machine_id
  lun                = count.index + 1
  caching            = "ReadWrite"
  depends_on = [
    azurerm_managed_disk.additional_managed_disk
  ]
}