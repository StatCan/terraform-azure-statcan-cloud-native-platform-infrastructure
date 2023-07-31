###########################################################
# Argo Workflows
###########################################################

resource "azurerm_storage_account" "workflows" {
  name                            = replace("${var.prefix}-sa-workflows", "-", "")
  location                        = var.azure_region
  resource_group_name             = azurerm_resource_group.platform.name
  account_kind                    = "StorageV2"
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  access_tier                     = "Hot"
  enable_https_traffic_only       = true
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"

  tags = var.tags

  depends_on = [
    azurerm_role_assignment.platform_rg_owner_ci
  ]

  lifecycle {
    ignore_changes = [tags.DateCreatedModified]
  }
}
