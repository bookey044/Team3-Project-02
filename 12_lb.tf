/////////////////////////////////////////////////////
//
// --- 로드밸런서 정의 시작 ---
//
/////////////////////////////////////////////////////

resource "azurerm_lb" "team3_lb" {
  name                = "team3-lb"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = azurerm_virtual_network.team3_vnet1.location
  sku                 = var.stand

  frontend_ip_configuration {
    name                 = "lbpublicip"
    public_ip_address_id = azurerm_public_ip.team3_loadip.id
  }
}

/////////////////////////////////////////////////////
//
// --- 로드밸런서 백엔드 풀 정의 시작 ---
//
/////////////////////////////////////////////////////

resource "azurerm_lb_backend_address_pool" "team3_back" {
  name            = "team3-back"
  loadbalancer_id = azurerm_lb.team3_lb.id
}

resource "azurerm_lb_probe" "team3_lb_probe" {
  name                = "team3-lb-probe"
  loadbalancer_id     = azurerm_lb.team3_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/health.html"
  interval_in_seconds = 5
}
