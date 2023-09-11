###########################################################
# Vault
###########################################################

# Managed Identity
resource "azurerm_user_assigned_identity" "vault" {
  resource_group_name = azurerm_resource_group.backup.name
  location            = var.azure_region
  tags                = local.tags

  name = "${var.prefix}-msi-vault"

  depends_on = []
}

# Allow msi to assign our identity
resource "azurerm_role_assignment" "aad_pod_identity_vault_operator" {
  scope                = azurerm_user_assigned_identity.vault.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.kubernetes_identity_object_id
}
