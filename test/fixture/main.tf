provider "random" {
  version = "~> 2.1"
}

resource "random_id" "name" {
  byte_length = 8
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  version         = "~> 1.32.0"
}

provider "azuread" {
  version = "~> 0.5.1"
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
}

