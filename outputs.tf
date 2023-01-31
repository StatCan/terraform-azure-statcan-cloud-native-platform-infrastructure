output "cert_manager_identity_client_id" {
  value = azurerm_user_assigned_identity.cert_manager.client_id
}

output "cert_manager_identity_id" {
  value = azurerm_user_assigned_identity.cert_manager.id
}

output "dns_zone_resource_group_name" {
  value = "" # data.azurerm_dns_zone.cloud_statcan_ca.resource_group_name
}

output "dns_zone_name" {
  value = "" # data.azurerm_dns_zone.cloud_statcan_ca.name
}

output "dns_zone_subscription_id" {
  value = "" # data.azurerm_client_config.current.subscription_id
}

output "backup_resource_group_name" {
  value = azurerm_resource_group.backup.name
}

output "vault_identity_client_id" {
  value = azurerm_user_assigned_identity.vault.client_id
}

output "vault_identity_id" {
  value = azurerm_user_assigned_identity.vault.id
}

output "velero_identity_client_id" {
  value = azurerm_user_assigned_identity.velero.client_id
}

output "velero_identity_id" {
  value = azurerm_user_assigned_identity.velero.id
}

output "velero_storage_account_name" {
  value = azurerm_storage_account.velero.name
}

output "velero_storage_bucket_name" {
  value = azurerm_storage_container.velero.name
}

######################
### Argo Workflows ###
######################

output "platform_workflows_storage_account_name" {
  description = "The name of the workflows storage account."
  value       = azurerm_storage_account.workflows.name
}

output "platform_workflows_primary_access_key" {
  description = "The primary access key of the workflows storage account."
  value       = azurerm_storage_account.workflows.primary_access_key
}

output "platform_workflows_primary_blob_endpoint" {
  description = "The primary blob endpoint of the workflows storage account."
  value       = azurerm_storage_account.workflows.primary_blob_endpoint
}
