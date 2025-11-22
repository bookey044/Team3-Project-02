/////////////////////////////////////////////////////
//
// --- 오토 스케일 셋 설정 ---
//
/////////////////////////////////////////////////////

// todo : 스트레스 테스트 필요 (스케일 인 작동은 확인하는거 봐서 아웃도 작동할거라 추정)
resource "azurerm_monitor_autoscale_setting" "team3_auto" {
  name                = "team3-auto"
  resource_group_name = azurerm_resource_group.team3_rg.name
  location            = var.loca
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.team3_vmss.id
  enabled             = true

  profile {
    name = "team3-profile"
    capacity {
      default = 2
      minimum = 1
      maximum = 6
    }

    # 1. 확장 규칙 (Increase)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.team3_vmss.id
        time_grain         = "PT1M" # 데이터 샘플링 간격
        statistic          = "Average"
        time_window        = "PT5M" # 5분 동안 평가
        time_aggregation   = "Average"
        operator           = "GreaterThanOrEqual"
        threshold          = 10
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    # 2. 축소 규칙 (Decrease)
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.team3_vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThanOrEqual"
        threshold          = 20
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
