resource "azurerm_app_service_plan" "windows" {
  name                = "appserviceplan-windows"
  location            = var.location
  resource_group_name = basename(module.rg.id)
  kind                = "Windows"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

module "windows_appservice" {
  source          = "../.."
  rg_name         = basename(module.rg.id)
  rgid            = format("win%s", var.rgid)
  environment     = var.environment
  location        = var.location
  num             = 1
  slot_num        = var.slot_num
  plan            = azurerm_app_service_plan.windows.id
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled
  key_vault_id    = azurerm_key_vault_secret.test.key_vault_id
  secret_name     = var.secret_name

  storage_accounts = []
}
