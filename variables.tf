variable "rgid" {
  description = "RGID used for naming"
}
variable "location" {
  default = "southcentralus"
  description = "Location for resources to be created"
}

variable "plan" {
  description = "Azure App Service Plan resource ID"
}

variable "count" {
  default = "1"
}

variable "name_prefix" {
  default = ""
  description = "Allows users to override the standard naming prefix.  If left as an empty string, the standard naming conventions will apply."
}

variable "environment" {
  default = "dev"
  description = "Environment used in naming lookups"
}

variable "rg_name" {
  description = "Resource group name"
}

# Compute default name values
locals {
  env_id              = "${lookup(module.naming.env-map, var.environment, "ENV")}"
  type                = "${lookup(module.naming.type-map, "azurerm_app_service", "TYP")}"

  default_rgid        = "${var.rgid != "" ? var.rgid : "NORGID"}"
  default_name_prefix = "c${local.default_rgid}${local.env_id}"

  name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
  name                = "${local.name_prefix}${local.type}001"
}

# This module provides a data map output to lookup naming standard references
module "naming" {
  source = "git::ssh://git@github.com/clearesult/cr-azurerm-naming.git"
}
