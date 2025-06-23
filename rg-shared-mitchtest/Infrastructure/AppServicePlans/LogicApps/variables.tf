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
}

/**************************************************
Existing Resource Variables
***************************************************/

/**************************************************
New Resource Variables
***************************************************/
variable "resourceGroupName" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-shared"
}

locals {
  fullResourceGroupName = "${var.resourceGroupName}-${var.resourceSuffix}-${var.environment}-${var.locationSuffix}"
  actionGroupResourceGroupName = (
      var.environmentGroup == "npe" ? "${var.resourceGroupName}-${var.resourceSuffix}-dev-${var.locationSuffix}" :
      var.environmentGroup == "ppe" ? "${var.resourceGroupName}-${var.resourceSuffix}-stg-${var.locationSuffix}" :
      var.environmentGroup == "prd" ? "${var.resourceGroupName}-${var.resourceSuffix}-prd-${var.locationSuffix}" :
      null
    )

  tags = {
    "application-name"  = "mitchtest"
    "environment"       = var.environment
    "owner"             = "roopesh.subramanyam@justice.govt.nz"
    "primary-support"   = ""
    "rc-code"           = ""
    "secondary-support" = "Adaptiv"
  }
}

variable "aspSkuSize" {
  type        = string
  description = "The SKU to set the App Service Plan to e.g. WS1"
}
