/////////////////////////////////////////////////////
//
// --- 갤러리 설정 ---
//
/////////////////////////////////////////////////////

resource "azurerm_shared_image_gallery" "team3_imgallery" {
  name                = "team3imgallery"
  location            = var.loca
  resource_group_name = azurerm_resource_group.team3_rg.name
}

resource "azurerm_shared_image" "team3_image" {
  name                         = "team3image"
  gallery_name                 = azurerm_shared_image_gallery.team3_imgallery.name
  resource_group_name          = azurerm_resource_group.team3_rg.name
  location                     = var.loca
  os_type                      = "Linux"
  hyper_v_generation           = "V2"
  architecture                 = "x64"
  min_recommended_vcpu_count   = 1
  max_recommended_vcpu_count   = 1
  min_recommended_memory_in_gb = 2
  max_recommended_memory_in_gb = 4
  identifier {
    publisher = local.publish
    offer     = local.offer
    sku       = local.sku
  }
}

resource "azurerm_shared_image_version" "team3_version" {
  name                = "1.0.0"
  gallery_name        = azurerm_shared_image_gallery.team3_imgallery.name
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  image_name          = azurerm_shared_image.team3_image.name
  managed_image_id    = azurerm_image.team3_image.id
  target_region {
    name                   = var.loca
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }
}


