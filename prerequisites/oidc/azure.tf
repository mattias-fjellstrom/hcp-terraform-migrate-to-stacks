data "azuread_client_config" "current" {}

resource "azuread_application" "hcp_terraform" {
  display_name = "hcp-terraform"
}

resource "azuread_service_principal" "hcp_terraform" {
  client_id = azuread_application.hcp_terraform.client_id
}

resource "azurerm_role_assignment" "contributor" {
  scope                = "/subscriptions/${var.azure_subscription_id}"
  principal_id         = azuread_service_principal.hcp_terraform.object_id
  role_definition_name = "Contributor"
}

locals {
  workspace_sub = join(":", [
    "organization",
    var.hcp_terraform_organization,
    "project",
    local.source_project,
    "workspace",
    local.source_workspace,
    "run_phase",
    "*"
  ])

  stack_sub = join(":", [
    "organization",
    var.hcp_terraform_organization,
    "project",
    local.destination_project,
    "stack",
    local.destination_stack,
    "*"
  ])
}

resource "msgraph_resource" "flex_fic_stack" {
  url         = "applications/${azuread_application.hcp_terraform.object_id}/federatedIdentityCredentials"
  api_version = "beta"

  body = {
    name      = "stack"
    issuer    = "https://app.terraform.io"
    audiences = ["api://AzureADTokenExchange"]
    claimsMatchingExpression = {
      value           = "claims['sub'] matches '${local.stack_sub}'"
      languageVersion = 1
    }
  }
}

resource "msgraph_resource" "flex_fic_workspace" {
  url         = "applications/${azuread_application.hcp_terraform.object_id}/federatedIdentityCredentials"
  api_version = "beta"

  body = {
    name      = "workspace"
    issuer    = "https://app.terraform.io"
    audiences = ["api://AzureADTokenExchange"]
    claimsMatchingExpression = {
      value           = "claims['sub'] matches '${local.workspace_sub}'"
      languageVersion = 1
    }
  }

  depends_on = [
    msgraph_resource.flex_fic_stack,
  ]
}
