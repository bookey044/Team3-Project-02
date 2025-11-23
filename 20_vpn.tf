/////////////////////////////////////////////////////
//
// --- VPN Gateway 설정 ---
//
/////////////////////////////////////////////////////

// ------------------------------------------------------------------------------------------------
// 1. vpn_root_cert.cer => 실행 후, 신뢰할 수 있는 루트 인증 기관에 등록할것
// 2. vpn_client_cert.pfx => 실행 후, 개인용에 등록할것
// 3. Azure VPN Gateway 에서 VPN 클라이언트 받은 뒤 VpnClientSetupAmd64.exe 실행하여 VPN 등록 이후 연결 (설정 - VPN 연결)
// 4. cmd 에서 ping , ssh 성공하면 끝 (10.0.6.4)
// ------------------------------------------------------------------------------------------------

# NSG 규칙: VPN 클라이언트 (172.16.201.0/24)에서 SSH(22) 접속 허용
resource "azurerm_network_security_rule" "vpn_rule_ssh" {
  name                        = "Allow-SSH-from-VPN-Client"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = azurerm_virtual_network_gateway.team3_vpn_gw.vpn_client_configuration[0].address_space[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.team3_rg.name
  network_security_group_name = azurerm_network_security_group.team3_nsg_ftp.name
}

# NSG 규칙: VPN 클라이언트 (172.16.201.0/24)에서 Ping(ICMP) 허용
resource "azurerm_network_security_rule" "vpn_rule_icmp" {
  name                        = "Allow-ICMP-from-VPN-Client"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = azurerm_virtual_network_gateway.team3_vpn_gw.vpn_client_configuration[0].address_space[0]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.team3_rg.name
  network_security_group_name = azurerm_network_security_group.team3_nsg_ftp.name
}

# Virtual Network Gateway 리소스 정의 (VPN GW)
resource "azurerm_virtual_network_gateway" "team3_vpn_gw" {
  name                = "team3-vpn-gateway"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw1"
  active_active = false
  enable_bgp    = false

  vpn_client_configuration {
    address_space        = ["172.16.201.0/24"]
    vpn_client_protocols = ["SSTP"]

    root_certificate {
      name             = "team3-root-cert"
      public_cert_data = trimspace(replace(replace(file("vpn_root_cert.cer"), "-----BEGIN CERTIFICATE-----", ""), "-----END CERTIFICATE-----", ""))
    }
  }

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.team3_vpnip.id
    private_ip_address_allocation = var.dynamic
    subnet_id                     = azurerm_subnet.team3_gateway_subnet.id
  }
}


