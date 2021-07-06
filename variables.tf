variable "prefix" {
  description = "Prefix for Azure resources"
}

variable "azure_region" {
  description = "Region to deploy Azure resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags attached to Azure resource"
  default     = {}
}

variable "node_resource_group_name" {}

variable "kubernetes_identity_object_id" {}

variable "dns_zone_id" {
  description = "Azure DNS Zone ID"
}

variable "velero_storage_account_subnets" {
  description = "The subnets from which the Storage Account backing Velero can be accessed."
  type        = list(string)
}
