/////////////////////////////////////////////////////
//
// --- 가상 머신 스케일 셋 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_linux_virtual_machine_scale_set" "team3_vmss" {
  name                = "team3-vmss"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  instances           = 1
  source_image_id     = azurerm_shared_image_version.team3_version.id
  admin_username      = "team3"
  sku                 = local.size
  upgrade_mode        = "Manual"

  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.sku
  }

  admin_ssh_key {
    username   = "team3"
    public_key = file(local.keypath)
  }

  os_disk {
    caching              = local.rw
    storage_account_type = "StandardSSD_LRS"
  }

  network_interface {
    name                      = "team3-vmssnic"
    primary                   = true
    network_security_group_id = azurerm_network_security_group.team3_nsg_http.id
    ip_configuration {
      name                                   = "team3-vmss-ip"
      primary                                = true
      subnet_id                              = azurerm_subnet.team3_web1.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.team3_back.id]
    }
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}
