/////////////////////////////////////////////////////
//
// --- 로드밸런서 백엔드 풀 규칙 연관 정의 시작 ---
//
/////////////////////////////////////////////////////

resource "azurerm_network_interface_backend_address_pool_association" "team3_lbback1" {
  network_interface_id    = azurerm_network_interface.team3_web1_nic.id
  ip_configuration_name   = "team3-web1-nic-ipconf"
  backend_address_pool_id = azurerm_lb_backend_address_pool.team3_back.id
}

resource "azurerm_network_interface_backend_address_pool_association" "team3_lbback2" {
  network_interface_id    = azurerm_network_interface.team3_web2_nic.id
  ip_configuration_name   = "team3-web2-nic-ipconf"
  backend_address_pool_id = azurerm_lb_backend_address_pool.team3_back.id
}
