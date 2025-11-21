/////////////////////////////////////////////////////
//
// --- Azure Provider 기본 설정 ---
//
/////////////////////////////////////////////////////

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.52.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subid

  features {
    resource_group {    
      prevent_deletion_if_contains_resources = false # 그룹 내의 모든 리소스들도 함께 삭제되도록 허용합니다. (false)
    }
  }
}