/////////////////////////////////////////////////////
//
// --- DNS 설정 ---
//
/////////////////////////////////////////////////////

# 퍼블릭 IP 리소스 정의
resource "azurerm_public_ip" "team3_load_ip" {
  name                = "team3-lb-public-ip"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  allocation_method   = var.static
  sku                 = var.stand # Load Balancer와 연결 시 보통 Standard SKU 사용
}

# Azure DNS 영역 정의 
resource "azurerm_dns_zone" "team3_dns" {
  name                = "bookey.store"
  resource_group_name = azurerm_resource_group.team3_rg.name
}

# DNS A 레코드 (@: 루트 도메인) 정의 
resource "azurerm_dns_a_record" "team3_record1" {
  name                = "@"
  zone_name           = azurerm_dns_zone.team3_dns.name
  resource_group_name = azurerm_resource_group.team3_rg.name
  ttl                 = 300
  records             = [azurerm_public_ip.team3_loadip.ip_address]
}                        

# DNS A 레코드 (www: 서브 도메인) 정의 
resource "azurerm_dns_a_record" "team3_record2" {
  name                = "www"
  zone_name           = azurerm_dns_zone.team3_dns.name
  resource_group_name = azurerm_resource_group.team3_rg.name
  ttl                 = 300
  records             = [azurerm_public_ip.team3_loadip.ip_address]
}





