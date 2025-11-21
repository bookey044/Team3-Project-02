/////////////////////////////////////////////////////
//
// --- VNet 피어링 설정 ---
//
// team3_vnet1 (10.0.0.0/16) <-> team3_vnet2 (20.0.0.0/16)
// (VNet2 Bas -> VNet1 Web/DB 사설 통신을 위해 필수)
//
/////////////////////////////////////////////////////

# 1. VNet1 -> VNet2 방향 피어링
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = "peer-vnet1-to-vnet2"
  resource_group_name       = azurerm_resource_group.team3_rg.name
  virtual_network_name      = azurerm_virtual_network.team3_vnet1.name // 피어링을 시작하는 VNet (Web/DB)
  remote_virtual_network_id = azurerm_virtual_network.team3_vnet2.id   // 연결 대상 VNet (Bas)

  allow_virtual_network_access = true // VNet 피어링을 통한 VNet 간 통신을 허용합니다. (Bas -> Web1/Web2 SSH 통신에 필수)

  allow_forwarded_traffic = false // 다른 VNet에서 넘어온 트래픽 허용 여부
  allow_gateway_transit   = false // 게이트웨이 전송 허용 여부 (VNet1에 VPN Gateway가 있을 때 VNet2가 사용하도록 허용)
  use_remote_gateways     = false // 원격 VNet2에 게이트웨이가 있을 때 VNet1이 사용하도록 설정
}

# 2. VNet2 -> VNet1 방향 피어링 (양방향 통신을 위해 필수)
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = "peer-vnet2-to-vnet1"
  resource_group_name       = azurerm_resource_group.team3_rg.name
  virtual_network_name      = azurerm_virtual_network.team3_vnet2.name // 피어링을 시작하는 VNet (Bas)
  remote_virtual_network_id = azurerm_virtual_network.team3_vnet1.id   // 연결 대상 VNet (Web/DB)

  allow_virtual_network_access = true // VNet 피어링을 통한 VNet 간 통신을 허용합니다. (Web1/Web2 -> Bas 통신에 필수)

  allow_forwarded_traffic = false
  allow_gateway_transit   = false
  use_remote_gateways     = false // 원격 VNet1에 게이트웨이가 있을 때 VNet2가 사용하도록 설정
}
