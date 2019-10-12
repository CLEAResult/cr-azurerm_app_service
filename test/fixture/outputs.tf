# Resource group outputs
#
output "resource_group_id" {
  value = module.rg.id
}

output "resource_group_reader_group_name" {
  value = module.rg.readerName
}

#
# Web application outputs
#
output "webapp_id" {
  value = module.linux_appservice.*.id
}

output "webapp_app_service_default_url" {
  value = module.linux_appservice.*.app_service_default_url
}

output "webapp_outbound_ip_addresses" {
  value = module.linux_appservice.*.outbound_ip_addresses
}

output "webapp_msi_principal_id" {
  value = module.linux_appservice.msi_principal_id
}

output "webapp_msi_tenant_id" {
  value = module.linux_appservice.msi_tenant_id
}

output "webapp_appServiceName" {
  value = module.linux_appservice.appServiceName
}

