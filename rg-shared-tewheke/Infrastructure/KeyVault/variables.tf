/**************************************************
Global Variables
***************************************************/
variable "location" {
  type        = string
  description = "The Azure location in which the deployment is happening"
}

variable "locationSuffix" {
  type        = string
  description = "The Azure location in which the deployment is happening"
}

variable "resourceSuffix" {
  type        = string
  description = "A suffix for naming"
}

variable "environment" {
  type        = string
  description = "Environment"
}


/**************************************************
Existing Resource Variables
***************************************************/
variable "networkingResourceGroupName" {
  type        = string
  description = "The name of the networking resource group"
  default     = "rg-networking"
}

/**************************************************
New Resource Variables
***************************************************/
variable "resourceGroupName" {
  type        = string
  description = "The name of the resource group to deploy to"
  default     = "rg-shared"
}

locals {
  fullResourceGroupName = "${var.resourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}

variable "keyVaultSku" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
}

variable "githubServicePrincipalId" {
  type        = string
  description = "The Object ID value for the Enterprise Application entity that represents the identity we use for GitHub deployments"
}
