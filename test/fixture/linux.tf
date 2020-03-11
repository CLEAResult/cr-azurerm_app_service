resource "azurerm_app_service_plan" "linux" {
  name                = "appserviceplan-linux"
  location            = var.location
  resource_group_name = basename(module.rg.id)
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

module "linux_appservice" {
  source                   = "../.."
  rg_name                  = basename(module.rg.id)
  rgid                     = var.rgid
  environment              = var.environment
  location                 = var.location
  name_prefix              = format("%s2", random_string.test.result)
  num                      = 1
  slot_num                 = var.slot_num
  plan                     = azurerm_app_service_plan.linux.id
  subscription_id          = var.subscription_id
  http2_enabled            = var.http2_enabled
  secure_app_settings_refs = { "testsecret" : azurerm_key_vault_secret.test.id }
  azure_registry_name      = var.azure_registry_name
  azure_registry_rg        = var.azure_registry_rg

  storage_accounts = [
    {
      name         = "data"
      type         = "AzureBlob"
      account_name = azurerm_storage_account.test.name
      share_name   = azurerm_storage_container.test.name
      access_key   = azurerm_storage_account.test.primary_access_key
      mount_path   = "/var/data"
    },
    {
      name         = "files"
      type         = "AzureFiles"
      account_name = azurerm_storage_account.test.name
      share_name   = azurerm_storage_share.test.name
      access_key   = azurerm_storage_account.test.primary_access_key
      mount_path   = "/var/files"
    }
  ]
}

resource "azurerm_storage_account" "test" {
  name                     = format("sa%s", random_string.test.result)
  resource_group_name      = basename(module.rg.id)
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "test" {
  name                 = "files"
  storage_account_name = azurerm_storage_account.test.name
  quota                = 50
}

