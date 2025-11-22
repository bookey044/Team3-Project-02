/////////////////////////////////////////////////////
//
// --- 가상 머신 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_linux_virtual_machine" "team3_bas_vm" {
  name                  = "team3-bas-vm"
  resource_group_name   = azurerm_resource_group.team3_rg.name
  location              = azurerm_resource_group.team3_rg.location
  size                  = local.size
  admin_username        = local.user
  network_interface_ids = [azurerm_network_interface.team3_bas_nic.id]

  // SSH 인증 키 설정
  admin_ssh_key {
    username   = local.user
    public_key = file(local.keypath)
  }

  // 초기 가상머신 설정 파일 (설치 후 초기 1회 실행)
  user_data = base64encode(file("Init_bas.sh"))

  # VM의 운영 체제(OS)가 설치될 가상 하드 디스크(VHD)의 설정을 정의합니다.
  os_disk {
    caching              = local.rw
    storage_account_type = local.type
  }

  # VM 생성에 사용될 마켓플레이스 이미지(OS 템플릿)의 정보를 지정합니다.
  source_image_reference {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
    version   = local.ver
  }

  # 마켓플레이스 이미지 사용에 필요한 추가적인 라이선스/청구 플랜 정보를 정의합니다.
  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.pname
  }

  # VM 부팅 중 발생할 수 있는 문제(화면 캡처 및 직렬 로그)를 기록하는 기능을 설정합니다.
  boot_diagnostics {
    storage_account_uri = null # Azure가 VM이 속한 리소스 그룹 내에서 관리되는 부트 진단용 저장소 계정을 자동으로 사용하도록 처리합니다. (null)
  }
}

resource "azurerm_linux_virtual_machine" "team3_web1_vm" {
  name                  = "team3-web1-vm"
  resource_group_name   = azurerm_resource_group.team3_rg.name
  location              = azurerm_resource_group.team3_rg.location
  size                  = local.size
  admin_username        = local.user
  network_interface_ids = [azurerm_network_interface.team3_web1_nic.id]

  admin_ssh_key {
    username   = local.user
    public_key = file(local.keypath)
  }

  user_data = base64encode(file("Init_web.sh"))

  os_disk {
    caching              = local.rw
    storage_account_type = local.type
  }

  source_image_reference {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
    version   = local.ver
  }

  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.pname
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

resource "azurerm_linux_virtual_machine" "team3_web2_vm" {
  name                  = "team3-web2-vm"
  resource_group_name   = azurerm_resource_group.team3_rg.name
  location              = azurerm_resource_group.team3_rg.location
  size                  = local.size
  admin_username        = local.user
  network_interface_ids = [azurerm_network_interface.team3_web2_nic.id]

  admin_ssh_key {
    username   = local.user
    public_key = file(local.keypath)
  }

  user_data = base64encode(file("Init_web.sh"))

  os_disk {
    caching              = local.rw
    storage_account_type = local.type
  }

  source_image_reference {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
    version   = local.ver
  }

  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.pname
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

resource "azurerm_linux_virtual_machine" "team3_db_vm" {
  name                  = "team3-db-vm"
  resource_group_name   = azurerm_resource_group.team3_rg.name
  location              = azurerm_resource_group.team3_rg.location
  size                  = local.size
  admin_username        = local.user
  network_interface_ids = [azurerm_network_interface.team3_db_nic.id]

  admin_ssh_key {
    username   = local.user
    public_key = file(local.keypath)
  }

  user_data = base64encode(file("Init_db.sh"))

  os_disk {
    caching              = local.rw
    storage_account_type = local.type
  }

  source_image_reference {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
    version   = local.ver
  }

  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.pname
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}
