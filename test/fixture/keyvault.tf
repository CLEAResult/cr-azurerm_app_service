resource "azurerm_key_vault" "test" {
  name                        = format("vault%s", random_string.test.result)
  location                    = var.location
  resource_group_name         = basename(module.rg.id)
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

# For the ID running the test
resource "azurerm_key_vault_access_policy" "test" {
  key_vault_id       = azurerm_key_vault.test.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["delete", "get", "purge", "set"]
}

resource "azurerm_key_vault_secret" "test" {
  key_vault_id = azurerm_key_vault.test.id
  name         = var.secret_name
  value        = "secretvalue"
  depends_on   = [azurerm_key_vault_access_policy.test]
}

