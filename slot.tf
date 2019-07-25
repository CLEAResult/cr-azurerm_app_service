resource "azurerm_app_service_slot" "app" {
  name                = format("%s%03d-slot", local.name, count.index + 1)
  count               = var.slot_num
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = var.plan
  app_service_name    = basename(azurerm_app_service.app[0].id)
  enabled             = "true"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }

  lifecycle {
    ignore_changes = [
      id,
      app_service_plan_id,
      tags,
      app_settings,
    ]
  }

  https_only = "true"

  site_config {
    always_on        = "true"
    php_version      = var.win_php_version
    linux_fx_version = format("%s%s", var.fx, var.fx_version)
    http2_enabled    = var.http2_enabled
    ftps_state       = var.ftps_state

    default_documents = [
      "index.html",
      "index.php",
    ]
  }

  tags = {
    InfrastructureAsCode = "True"
  }
}

