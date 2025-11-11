# variables.tf -------------------------------------------------------------------
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "hcp_terraform_organization" {
  description = "HCP Terraform organization name"
  type        = string
}
