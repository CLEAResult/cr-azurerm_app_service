output "appService_default_url" {
  value = ["${azurerm_app_service.app.*.default_site_hostname}"]
}
