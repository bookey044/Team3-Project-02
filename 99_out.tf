/////////////////////////////////////////////////////
//
// --- 출력 변수 설정 ---
//
/////////////////////////////////////////////////////

output "bas_pub_ip" {
  value = azurerm_public_ip.team3_basip.ip_address
}

output "nat_pub_ip" {
  value = azurerm_public_ip.team3_natip.ip_address
}

output "load_pub_ip" {
  value = azurerm_public_ip.team3_loadip.ip_address
}

output "azure_dns_nameservers" {
  value       = azurerm_dns_zone.team3_dns.name_servers
}