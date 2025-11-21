/////////////////////////////////////////////////////
//
// --- 로드밸런서 백엔드 풀 규칙 정의 시작 ---
//
/////////////////////////////////////////////////////

resource "azurerm_lb_rule" "team3_lb_rule" {
  name                           = "team3-lb-rule"
  loadbalancer_id                = azurerm_lb.team3_lb.id
  frontend_ip_configuration_name = "lbpublicip"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.team3_back.id]
  probe_id                       = azurerm_lb_probe.team3_lb_probe.id
}
