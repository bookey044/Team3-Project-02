# --- 컴파일 변수 정의 시작 ---

output "bas_pub_ip" {
  value = azurerm_public_ip.team3_basip.ip_address
}

output "nat_pub_ip" {
  value = azurerm_public_ip.team3_natip.ip_address
}

output "load_pub_ip" {
  value = azurerm_public_ip.team3_loadip.ip_address
}
