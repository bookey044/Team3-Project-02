/////////////////////////////////////////////////////
//
// --- 네트워크 보안 그룹 설정 --- (team3_vnet1)
//
/////////////////////////////////////////////////////

# Web1, Web2
resource "azurerm_network_security_group" "team3_nsg_http" {
  name                = "team3-nsg-http"
  location            = azurerm_virtual_network.team3_vnet1.location
  resource_group_name = azurerm_resource_group.team3_rg.name

  security_rule {
    name                       = "ssh-http"
    priority                   = 200
    direction                  = "Inbound" # "Inbound"는 외부에서 Azure 리소스로 들어오는 트래픽입니다.
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "10.0.0.0/16"
    destination_port_ranges    = ["22", "80"]
  }
}

# DB
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

resource "azurerm_network_security_group" "team3_nsg_ftp" {
  name                = "team3-nsg-ftp"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
}

/////////////////////////////////////////////////////
//
// --- 네트워크 보안 그룹 설정 --- (team3_vnet2)
//
/////////////////////////////////////////////////////

# Bas
resource "azurerm_network_security_group" "team3_nsg_ssh" {
  name                = "team3-nsg-ssh"
  location            = azurerm_virtual_network.team3_vnet2.location // Vnet 설정
  resource_group_name = azurerm_resource_group.team3_rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefixes    = ["61.108.60.26", "10.0.0.0/16"]
    source_port_range          = "*"
    destination_address_prefix = "20.0.0.0/16"
    destination_port_range     = "22"
  }
}


