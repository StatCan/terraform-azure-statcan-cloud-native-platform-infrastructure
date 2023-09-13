###########################################################
# Velero
###########################################################
# Resources to allow Velero to perform backups.
# This allows for a recovery strategy in case of
# catastrophic loss of the AKS cluster resources.
###########################################################

resource "azurerm_resource_group" "backup" {
  name     = "${var.prefix}-rg-backup"
  location = var.azure_region
  tags     = local.tags
}

# CI SP be the owner of the resource group
resource "azurerm_role_assignment" "backup_rg_owner_ci" {
  scope                = azurerm_resource_group.backup.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Hosting-K8s be the reader of the resource group
resource "azurerm_role_assignment" "backup_rg_owner_hosting_k8s" {
  scope                = azurerm_resource_group.backup.id
  role_definition_name = "Reader"
  principal_id         = "2e1abffc-60c6-4bbe-9e3c-e051fde82af5"
}

resource "azurerm_storage_account" "velero" {
  name                            = replace("${var.prefix}-sa-velero", "-", "")
  location                        = var.azure_region
  resource_group_name             = azurerm_resource_group.backup.name
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "RAGZRS"
  access_tier                     = "Hot"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.backup_rg_owner_ci
  ]

  lifecycle {
    ignore_changes = [tags.DateCreatedModified]
  }
}

resource "azurerm_advanced_threat_protection" "velero" {
  target_resource_id = azurerm_storage_account.velero.id
  enabled            = true
}

resource "azurerm_storage_account_network_rules" "velero" {
  storage_account_id = azurerm_storage_account.velero.id

  default_action             = "Deny"
  virtual_network_subnet_ids = var.velero_storage_account_subnets
  bypass                     = ["Logging", "Metrics", "AzureServices"]
}

resource "azurerm_storage_container" "velero" {
  name                  = "velero"
  storage_account_name  = azurerm_storage_account.velero.name
  container_access_type = "private"
}

# Managed Identity
resource "azurerm_user_assigned_identity" "velero" {
  resource_group_name = azurerm_resource_group.backup.name
  location            = var.azure_region
  tags                = local.tags

  name = "${var.prefix}-msi-velero"

  depends_on = [
    azurerm_role_assignment.backup_rg_owner_ci
  ]
}

resource "azurerm_role_assignment" "velero_storage_key_operator" {
  scope                = azurerm_storage_account.velero.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_snapshot_management" {
  scope                = azurerm_resource_group.backup.id
  role_definition_name = "Velero Snapshot Management"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_disk_management" {
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Velero Disk Management"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

# Allow msi to assign our identity
resource "azurerm_role_assignment" "aad_pod_identity_velero_operator" {
  scope                = azurerm_user_assigned_identity.velero.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.kubernetes_identity_object_id
}
