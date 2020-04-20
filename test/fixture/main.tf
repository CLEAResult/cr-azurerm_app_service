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
  features {}
}

provider "azuread" {
  version = "~> 0.7.0"
}

module "rg" {
  source          = "git::https://github.com/clearesult/cr-azurerm_resource_group.git?ref=v1.2.2"
  rgid            = var.rgid
  environment     = var.environment
  location        = var.location
  create_date     = var.create_date
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}
