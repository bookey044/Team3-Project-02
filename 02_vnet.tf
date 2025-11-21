/////////////////////////////////////////////////////
//
// --- 가상 네트워크 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_virtual_network" "team3_vnet1" {
  name                = "team3-vnet1"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "team3_vnet2" {
  name                = "team3-vnet2"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  address_space       = ["20.0.0.0/16"]
}
