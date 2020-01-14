resource "azurerm_app_service_slot" "app" {
  name                = format("%s%03d-slot", local.name, count.index + 1)
  count               = var.slot_num
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = local.plan
  app_service_name    = basename(azurerm_app_service.app[0].id)
  enabled             = "true"

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge(var.app_settings, local.secure_app_settings, local.app_settings)

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
    app_command_line = var.command
    php_version      = var.win_php_version
    linux_fx_version = local.linux_fx_version
    http2_enabled    = var.http2_enabled
    ftps_state       = var.ftps_state

    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        ip_address  = split("/", ip_restriction.value)[0]
        subnet_mask = cidrnetmask(ip_restriction.value)
      }
    }
  
    default_documents = [
      "index.html",
      "index.php",
    ]
  }

  tags = merge({
    InfrastructureAsCode = "True"
  }, var.tags)
}

