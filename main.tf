resource "azurerm_app_service" "app" {
  name                = format("%s%03d", local.name, count.index + 1)
  count               = var.num
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = var.plan
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

resource "azuread_group" "WebsiteContributor" {
  name = format("g%s%s%s_AZ_WebsiteContributor", local.default_rgid, local.env_id, local.rg_type)
}

resource "azurerm_role_assignment" "WebsiteContributor" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.rg_name)
  role_definition_name = "Website Contributor"
  principal_id         = azuread_group.WebsiteContributor.id
}

