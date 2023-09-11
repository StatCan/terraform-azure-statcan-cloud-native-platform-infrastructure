###########################################################
# PLATFORM RESOURCE GROUP
###########################################################
# Resource group to store cluster-related resource.
###########################################################
resource "azurerm_resource_group" "platform" {
  name     = "${var.prefix}-rg-platform"
  location = var.azure_region
  tags     = local.tags
}

# CI SP be the owner of the platform resource group
resource "azurerm_role_assignment" "platform_rg_owner_ci" {
  scope                = azurerm_resource_group.platform.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Hosting-K8s be the owner of the platform resource group
resource "azurerm_role_assignment" "platform_rg_owner_hosting_k8s" {
  scope                = azurerm_resource_group.platform.id
  role_definition_name = "Owner"
  principal_id         = "2e1abffc-60c6-4bbe-9e3c-e051fde82af5"
}
