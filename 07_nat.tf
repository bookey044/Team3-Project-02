/////////////////////////////////////////////////////
//
// --- NAT 게이트웨이 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_nat_gateway" "team3_nat" {
  name                    = "team3-nat"
  resource_group_name     = azurerm_resource_group.team3_rg.name
  location                = azurerm_resource_group.team3_rg.location
  sku_name                = var.stand
  idle_timeout_in_minutes = 4 # 연결이 4분 동안 사용되지 않으면 연결이 닫힙니다.
}

resource "azurerm_nat_gateway_public_ip_association" "team3_nat_pubip" {
  nat_gateway_id       = azurerm_nat_gateway.team3_nat.id
  public_ip_address_id = azurerm_public_ip.team3_natip.id
}
