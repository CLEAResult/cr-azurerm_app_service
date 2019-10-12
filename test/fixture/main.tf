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
  version         = "~> 1.35.0"
}

provider "azuread" {
  version = "~> 0.6.0"
}

module "rg" {
  source          = "git::https://github.com/clearesult/cr-azurerm_resource_group.git?ref=v1.2.2"
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  create_date     = var.create_date
  subscription_id = var.subscription_id
}

resource "azurerm_key_vault" "test" {
  name                        = format("vault%s", random_string.test.result)
  location                    = var.location
  resource_group_name         = basename(module.rg.id)
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"

  #network_acls {
  #  default_action = "Deny"
  #  bypass         = "AzureServices"
  #}
}

#resource "azurerm_key_vault_access_policy" "test" {
#  count              = var.secret_name != "" ? 1 : 0
#  key_vault_id       = azurerm_key_vault.test.id
#  tenant_id          = data.azurerm_client_config.current.tenant_id
#  object_id          = "SET ME - requires service principal ID or MSI"
#  secret_permissions = ["get", "set"]
#}

#resource "azurerm_key_vault_secret" "test" {
#  key_vault_id = azurerm_key_vault.test.id
#  name         = var.secret_name
#  value        = "secretvalue"
#  depends_on   = [azurerm_key_vault_access_policy.test]
#}

data "azurerm_client_config" "current" {}
