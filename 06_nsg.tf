/////////////////////////////////////////////////////
//
// --- 네트워크 보안 그룹 설정 --- (team3_vnet1)
//
/////////////////////////////////////////////////////

// Web1, Web2
resource "azurerm_network_security_group" "team3_nsg_http" {
  name                = "team3-nsg-http"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  security_rule {
    name                       = "ssh-http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_ranges    = ["22", "80"]
  }
}

// DB
resource "azurerm_network_security_group" "team3_nsg_db" {
  name                = "team3-nsg-db"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  security_rule {
    name                       = "ssh-db"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_ranges    = ["22", "3306"]
  }
}

/////////////////////////////////////////////////////
//
// --- 네트워크 보안 그룹 설정 --- (team3_vnet2)
//
/////////////////////////////////////////////////////

// Bas
resource "azurerm_network_security_group" "team3_nsg_ssh" {
  name = "team3-nsg-ssh" 
  location            = azurerm_virtual_network.team3_vnet2.location // Vnet 설정
  resource_group_name = azurerm_resource_group.team3_rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound" // 트래픽의 방향을 지정합니다. "Inbound"는 외부에서 Azure 리소스로 들어오는 트래픽입니다.
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["61.108.60.26", "10.0.0.0/16"] // 1. "61.108.60.26": 특정 외부 고정 IP를 허용합니다. "10.0.0.0/16": Azure VNet 내부의 넓은 사설 IP 대역을 허용합니다. (VNet 내부 접속 허용)
    source_port_range          = "*"
    destination_address_prefix = "20.0.0.0/16" // 트래픽이 도착할 대상 IP 주소 범위입니다, 이 서브넷 범위 내의 모든 리소스(VM)로의 접속을 허용합니다.
    destination_port_range     = "22"
  }
}


