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

resource "azuread_application_password" "hcp_terraform" {
  application_id = azuread_application.hcp_terraform.id
}
