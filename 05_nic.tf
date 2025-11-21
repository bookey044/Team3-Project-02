/////////////////////////////////////////////////////
//
// --- 네트워크 인터페이스 설정 --- (team3_vnet1)
//
/////////////////////////////////////////////////////

resource "azurerm_network_interface" "team3_web1_nic" {
  name                = "team3-web1-nic"
  location            = azurerm_virtual_network.team3_vnet1.location // Vnet 설정
  resource_group_name = azurerm_resource_group.team3_rg.name

  ip_configuration {
    name                          = "team3-web1-nic-ipconf"
    subnet_id                     = azurerm_subnet.team3_web1.id
    private_ip_address_allocation = var.static
    private_ip_address_version    = var.ip4
    private_ip_address            = "10.0.2.4" // Azure 에서 0 (네트워크 주소), 1 (게이트웨이), 2/3 (DNS 리졸버) 으로 쓰기 때문에 4부터 시작함
  }
}

resource "azurerm_network_interface" "team3_web2_nic" {
  name                = "team3-web2-nic"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  ip_configuration {
    name                          = "team3-web2-nic-ipconf"
    subnet_id                     = azurerm_subnet.team3_web2.id
    private_ip_address_allocation = var.static
    private_ip_address_version    = var.ip4
    private_ip_address            = "10.0.3.4"
  }
}

resource "azurerm_network_interface" "team3_db_nic" {
  name                = "team3-db-nic"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  ip_configuration {
    name                          = "team3-db-nic-ipconf"
    subnet_id                     = azurerm_subnet.team3_db.id
    private_ip_address_allocation = var.static
    private_ip_address_version    = var.ip4
    private_ip_address            = "10.0.4.4"
  }
}

/////////////////////////////////////////////////////
//
// --- 네트워크 인터페이스 설정 --- (team3_vnet2)
//
/////////////////////////////////////////////////////

resource "azurerm_network_interface" "team3_bas_nic" {
  name                = "team3-bas-nic"
  location            = azurerm_virtual_network.team3_vnet2.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  ip_configuration {
    name                          = "team3-bas-nic-ipconf"
    subnet_id                     = azurerm_subnet.team3_bas.id
    private_ip_address_allocation = var.static
    private_ip_address_version    = var.ip4
    private_ip_address            = "20.0.0.4"
    public_ip_address_id          = azurerm_public_ip.team3_basip.id
  }
}

