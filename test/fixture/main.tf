provider "random" {
  version = "~> 2.1"
}

resource "random_string" "test" {
  length  = 9
  special = false
  upper   = false
  lower   = true
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~> 1.34.0"
}

provider "azuread" {
  version = "~> 0.6.0"
}

module "rg" {
  source          = "git::https://github.com/clearesult/cr-azurerm_resource_group.git?ref=v1.2.1"
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  create_date     = var.create_date
  subscription_id = var.subscription_id
}

module "appservice" {
  source          = "../.."
  rg_name         = basename(module.rg.id)
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  num             = 1
  slot_num        = var.slot_num
  plan            = var.plan
  subscription_id = var.subscription_id
  http2_enabled   = var.http2_enabled

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
  resource_group_name   = basename(module.rg.id)
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "test" {
  name                 = "files"
  storage_account_name = azurerm_storage_account.test.name
  quota                = 50
}

