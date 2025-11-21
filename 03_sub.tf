/////////////////////////////////////////////////////
//
// --- 서브넷 설정 --- (team3_vnet1)
//
/////////////////////////////////////////////////////

resource "azurerm_subnet" "team3_nat" {
  name                            = "team3-nat"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet1.name  # 이 서브넷이 속할 상위 가상 네트워크(VNet)를 참조합니다.
  address_prefixes                = ["10.0.1.0/24"] # 서브넷에 할당될 IP 주소 범위(CIDR 블록)입니다.
  default_outbound_access_enabled = true # 이 서브넷에서 아웃바운드 인터넷 접근을 활성화 (true)
}

resource "azurerm_subnet" "team3_web1" {
  name                            = "team3-web1"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet1.name
  address_prefixes                = ["10.0.2.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "team3_web2" {
  name                            = "team3-web2"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet1.name
  address_prefixes                = ["10.0.3.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "team3_db" {
  name                            = "team3-db"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet1.name
  address_prefixes                = ["10.0.4.0/24"]
  default_outbound_access_enabled = false
}

/////////////////////////////////////////////////////
//
// --- 서브넷 설정 --- (team3_vnet2)
//
/////////////////////////////////////////////////////

resource "azurerm_subnet" "team3_bas" {
  name                            = "team3-bas"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet2.name
  address_prefixes                = ["20.0.0.0/24"]
  default_outbound_access_enabled = true
}
