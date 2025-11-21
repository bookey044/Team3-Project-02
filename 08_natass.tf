/////////////////////////////////////////////////////
//
// --- NAT 게이트웨이 어소시에이션 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_subnet_nat_gateway_association" "team3_natweb1" {
  subnet_id      = azurerm_subnet.team3_web1.id
  nat_gateway_id = azurerm_nat_gateway.team3_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "team3_natweb2" {
  subnet_id      = azurerm_subnet.team3_web2.id
  nat_gateway_id = azurerm_nat_gateway.team3_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "team3_natdb" {
  subnet_id      = azurerm_subnet.team3_db.id
  nat_gateway_id = azurerm_nat_gateway.team3_nat.id
}
