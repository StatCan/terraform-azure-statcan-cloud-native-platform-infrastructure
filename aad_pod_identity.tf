###########################################################
# AAD Pod Identity
###########################################################
# Allow AAD Pod Identity to assign identities to our VMs.
# Note: any identity also needs "Managed Identity Operator
# permissions for the cluster identity)
###########################################################

data "azurerm_resource_group" "aks_node_resource_group" {
  name = var.node_resource_group_name
}

resource "azurerm_role_assignment" "aad_pod_identity_vm_contributor" {
  scope                = data.azurerm_resource_group.aks_node_resource_group.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = var.kubernetes_identity_object_id
}
