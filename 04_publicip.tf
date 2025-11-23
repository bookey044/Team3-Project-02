/////////////////////////////////////////////////////
//
// --- 공용 아이피 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_public_ip" "team3_basip" {
  name                = "team3-pubip"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  allocation_method   = var.static # IP 주소 할당 방식을 지정합니다. (정적) 
  sku                 = var.stand  # Standard SKU는 Zone-redundant(영역 중복) => zone 옵션 미 설정시 미적용
  ip_version          = var.ip4
}

resource "azurerm_public_ip" "team3_natip" {
  name                = "team3-natip"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  allocation_method   = var.static
  sku                 = var.stand
  ip_version          = var.ip4
}

resource "azurerm_public_ip" "team3_loadip" {
  name                = "team3-loadip"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  allocation_method   = var.static
  sku                 = var.stand
  ip_version          = var.ip4
}

resource "azurerm_public_ip" "team3_vpnip" {
  name                = "team3-vpnip"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
  allocation_method   = var.static
  sku                 = var.stand
  ip_version          = var.ip4
}
