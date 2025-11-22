# --- 가상머신 이미지 정의 시작 ---

resource "azurerm_managed_disk" "team3_disk" {
  name                 = "team3-disk"
  location             = var.loca
  resource_group_name  = azurerm_resource_group.team3_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Copy"
  disk_size_gb         = 10
  source_resource_id   = azurerm_linux_virtual_machine.team3_web1_vm.os_disk[0].id
  depends_on           = [azurerm_linux_virtual_machine.team3_web1_vm]
}

resource "azurerm_image" "team3_image" {
  name                = "team3-image"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  hyper_v_generation  = "V2"
  os_disk {
    managed_disk_id = azurerm_managed_disk.team3_disk.id
    os_type         = "Linux"
    os_state        = "Generalized"
    caching         = local.rw
    storage_type    = "StandardSSD_LRS"
  }
  depends_on = [azurerm_managed_disk.team3_disk]
}
