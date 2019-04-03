resource "azurerm_app_service" "app" {
  count               = "${var.count != "" ? var.count : "1"}"
  name                = "${local.name}"
  location            = "${var.location}"
  resource_group_name = "${var.rg_name}"
  app_service_plan_id = "${var.plan}"
  enabled = "true"

app_settings {
  WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
}
  lifecycle {
    ignore_changes = [
      "id",
      "app_service_plan_id",
      "tags"
    ]
  }

  https_only = "true"
  site_config {
    always_on = "true"
    php_version = "7.2"
    linux_fx_version = "PHP|7.2"
    default_documents = [
      "index.html",
      "index.php"
    ]
  }
}
