/////////////////////////////////////////////////////
//
// --- 네트워크 인터페이스 보안 그룹 연관 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_network_interface_security_group_association" "team3_bassg" {
    network_interface_id = azurerm_network_interface.team3_bas_nic.id
    network_security_group_id = azurerm_network_security_group.team3_nsg_ssh.id
}

resource "azurerm_network_interface_security_group_association" "team3_web1sg" {
    network_interface_id = azurerm_network_interface.team3_web1_nic.id
    network_security_group_id = azurerm_network_security_group.team3_nsg_http.id
}

resource "azurerm_network_interface_security_group_association" "team3_web2sg" {
    network_interface_id = azurerm_network_interface.team3_web2_nic.id
    network_security_group_id = azurerm_network_security_group.team3_nsg_http.id
}

resource "azurerm_network_interface_security_group_association" "team3_dbsg" {
    network_interface_id = azurerm_network_interface.team3_db_nic.id
    network_security_group_id = azurerm_network_security_group.team3_nsg_db.id
}