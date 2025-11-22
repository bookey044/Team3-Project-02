/////////////////////////////////////////////////////
//
// --- VPN Gateway 및 전용 VM 설정 ---
// (VPN 게이트웨이, 전용 FTP VM, NSG, 연결 모두 포함) => 기능 확인 후 각각의 기능을 기존 코드에 통합 시킬 예정임
//
/////////////////////////////////////////////////////

// ------------------------------------------------------------------------------------------------
// 1. vpn_root_cert.cer => 실행 후, 신뢰할 수 있는 루트 인증 기관에 등록할것
// 2. vpn_client_cert.pfx => 실행 후, 개인용에 등록할것
// 3. Azure VPN Gateway 에서 VPN 클라이언트 받은 뒤 VpnClientSetupAmd64.exe 실행하여 VPN 등록 이후 연결 (설정 - VPN 연결)
// 4. cmd 에서 ping , sftp 성공하면 끝 (10.0.6.4)
// ------------------------------------------------------------------------------------------------

// 1. VPN Gateway용 공용 IP 정의
resource "azurerm_public_ip" "team3_vpn_ip" {
  name                = "team3-vpn-public-ip"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  allocation_method   = var.static
  sku                 = var.stand
  ip_version          = var.ip4
}

# 2. VPN Gateway용 서브넷 정의 (이름은 반드시 'GatewaySubnet'이어야 함)
resource "azurerm_subnet" "team3_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.team3_rg.name
  virtual_network_name = azurerm_virtual_network.team3_vnet1.name
  address_prefixes     = ["10.0.5.0/24"] # VNet1 (10.0.0.0/16) 내부의 새로운 CIDR 블록
}

# 3. FTP VM 전용 서브넷 정의 (10.0.0.0/24)
resource "azurerm_subnet" "team3_ftp" {
  name                            = "team3-ftp"
  resource_group_name             = azurerm_resource_group.team3_rg.name
  virtual_network_name            = azurerm_virtual_network.team3_vnet1.name
  address_prefixes                = ["10.0.6.0/24"] # VNet1의 첫 번째 서브넷
  default_outbound_access_enabled = false
}

# 4. FTP VM 전용 네트워크 인터페이스 (NIC) 정의 (IP 10.0.6.4)
resource "azurerm_network_interface" "team3_ftp_nic" {
  name                = "team3-ftp-nic"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  ip_configuration {
    name                          = "team3-ftp-nic-ipconf"
    subnet_id                     = azurerm_subnet.team3_ftp.id
    private_ip_address_allocation = var.static
    private_ip_address_version    = var.ip4
    private_ip_address            = "10.0.6.4"
  }
}

# 5. VPN 전용 FTP VM 생성
resource "azurerm_linux_virtual_machine" "team3_ftp_vm" {
  name                  = "team3-ftp-vm"
  resource_group_name   = azurerm_resource_group.team3_rg.name
  location              = azurerm_resource_group.team3_rg.location
  size                  = local.size
  admin_username        = local.user
  network_interface_ids = [azurerm_network_interface.team3_ftp_nic.id]

  admin_ssh_key {
    username   = local.user
    public_key = file(local.keypath)
  }

  user_data = base64encode(file("Init_ftp.sh"))

  os_disk {
    caching              = local.rw
    storage_account_type = local.type
  }

  source_image_reference {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
    version   = local.ver
  }

  plan {
    publisher = local.publish
    product   = local.offer
    name      = local.pname
  }
}

# 6. VPN 접속 허용을 위한 Network Security Group (NSG) 정의
resource "azurerm_network_security_group" "team3_vpn_ftp_nsg" {
  name                = "team3-vpn-ftp-nsg"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
}

# 6-1. NSG 규칙: VPN 클라이언트 (172.16.201.0/24)에서 SSH(22) 접속 허용
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
  network_security_group_name = azurerm_network_security_group.team3_vpn_ftp_nsg.name
}

# 6-2. NSG 규칙: VPN 클라이언트 (172.16.201.0/24)에서 Ping(ICMP) 허용
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
  network_security_group_name = azurerm_network_security_group.team3_vpn_ftp_nsg.name
}

# 7. Virtual Network Gateway 리소스 정의 (VPN GW)
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
    public_ip_address_id          = azurerm_public_ip.team3_vpn_ip.id
    private_ip_address_allocation = var.dynamic
    subnet_id                     = azurerm_subnet.team3_gateway_subnet.id
  }
}

# 8. NSG를 FTP VM NIC에 연결 (최종 연결 단계)
resource "azurerm_network_interface_security_group_association" "team3_ftp_nic_vpn_nsg_association" {
  network_interface_id      = azurerm_network_interface.team3_ftp_nic.id
  network_security_group_id = azurerm_network_security_group.team3_vpn_ftp_nsg.id
}
