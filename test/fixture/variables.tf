variable "resource_group_name" {}

variable "rgid" {}

variable "environment" {}

variable "location" {}

variable "create_date" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "http2_enabled" {
  default = "true"
}

variable "slot_num" {}

variable "secret_name" {}

variable "azure_registry_name" {
  default = ""
}

variable "azure_registry_rg" {
  default = ""
}

variable "ip_restrictions" {
  default = []
}
