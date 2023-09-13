locals {
  tags = merge(var.tags, { ModuleName = "terraform-azure-statcan-cloud-native-platform-infrastructure" }, { ModuleVersion = "1.2.1" })
}
