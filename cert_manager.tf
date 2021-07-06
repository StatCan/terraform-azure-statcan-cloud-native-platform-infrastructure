###########################################################
# CERT-MANAGER
###########################################################
# Resources to allow cert-manager to issue certificates.
# This allows us to use DNS validation.
###########################################################

# Create an identity for cert-manager
resource "azurerm_user_assigned_identity" "cert_manager" {
  name                = "${var.prefix}-msi-cert-manager"
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.azure_region
  tags                = var.tags

  depends_on = [
    azurerm_role_assignment.platform_rg_owner_ci
  ]
}

# Allow cert-manager to contribute to the dns zone
resource "azurerm_role_assignment" "cert_manager_dns" {
  scope                = var.dns_zone_id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

# Allow AAD Pod Identity to assign the cert-manager identity
resource "azurerm_role_assignment" "aad_pod_identity_cert_manager_operator" {
  scope                = azurerm_user_assigned_identity.cert_manager.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.kubernetes_identity_object_id
}
