resource "tfe_variable_set" "azure" {
  name        = "AZURE-GLOBAL-OIDC"
  description = "Azure credentials for stacks migration"
  global      = true
}

resource "tfe_variable" "arm_subscription_id" {
  key             = "ARM_SUBSCRIPTION_ID"
  value           = var.azure_subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
}

resource "tfe_variable" "arm_tenant_id" {
  key             = "ARM_TENANT_ID"
  value           = data.azuread_client_config.current.tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
}

resource "tfe_variable" "tfc_azure_run_client_id" {
  key             = "TFC_AZURE_RUN_CLIENT_ID"
  value           = azuread_application.hcp_terraform.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key             = "TFC_AZURE_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
}

locals {
  source_project   = "demo-source-project"
  source_workspace = "demo-source-workspace"

  destination_project = "demo-destination-project"
  destination_stack   = "demo-destination-stack"
}

resource "tfe_project" "default" {
  name = local.source_project
}

resource "tfe_workspace" "default" {
  name       = local.source_workspace
  project_id = tfe_project.default.id

  force_delete = true
}

resource "tfe_variable" "location" {
  key          = "location"
  category     = "terraform"
  value        = "swedencentral"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "stacks" {
  key          = "stacks"
  category     = "terraform"
  value        = "false"
  workspace_id = tfe_workspace.default.id
}
