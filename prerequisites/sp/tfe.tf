resource "tfe_variable_set" "azure" {
  name        = "azure-credentials"
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

resource "tfe_variable" "arm_client_id" {
  key             = "ARM_CLIENT_ID"
  value           = azuread_application.hcp_terraform.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
}

resource "tfe_variable" "arm_client_secret" {
  key             = "ARM_CLIENT_SECRET"
  value           = azuread_application_password.hcp_terraform.value
  category        = "env"
  variable_set_id = tfe_variable_set.azure.id
  sensitive       = true
}

resource "tfe_project" "default" {
  name = "stacks-migration-demo"
}

resource "tfe_workspace" "default" {
  name       = "source-workspace"
  project_id = tfe_project.default.id
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
