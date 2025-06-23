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

variable "environmentGroup" {
  type        = string
  description = "Environemnts are grouped by production, pre production, and non-production"
}

/**************************************************
Existing Resource Variables
***************************************************/
variable "resourceGroupName-ManagementSubscription" {
  type        = string
  description = "The name of the Management subscription shared resource group"
  default     = "rg-fs-monitoring"
}

/**************************************************
New Resource Variables
***************************************************/
variable "resourceGroupName" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-shared"
}

variable "mitchtestOperationsEmailReceivers" {
  type = list(object({
    email = string
    name  = string
  }))
  description = "List of email receivers with email address and name"
}

locals {
  subscription_id       = data.azurerm_subscription.current.subscription_id
  fullResourceGroupName = "${var.resourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
}
