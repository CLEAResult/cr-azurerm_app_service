resource "azurerm_app_service" "app" {
  name                = "${local.name}${format("%03d", count.index + 1)}"
  count               = "${var.count}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  app_service_plan_id = "${var.plan}"
  enabled             = "true"

  identity {
    type = "SystemAssigned"
  }

  app_settings {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
  }

  lifecycle {
    ignore_changes = [
      "id",
      "app_service_plan_id",
      "tags",
    ]
  }

  https_only = "true"

  site_config {
    always_on        = "true"
    php_version      = "${var.win_php_version}"
    linux_fx_version = "${var.fx}|${var.fx_version}"

    default_documents = [
      "index.html",
      "index.php",
    ]
  }

  tags {
    InfrastructureAsCode = "True"
  }
}

# add site extension via ARM template
resource "azurerm_template_deployment" "extension" {
  name                = "${azurerm_app_service.app.name}-deploy"
  resource_group_name = "${var.rg_name}"

  template_body = "${file("${path.module}/azuredeploy.json")}"

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "siteName"         = "${azurerm_app_service.app.name}"
    "extensionName"    = "SecurityPackHttpsRedirectPlusHeadersMed"
    "extensionVersion" = "1.1.6"
  }

  deployment_mode = "Incremental"
  depends_on      = ["azurerm_app_service.app"]
}
