/**************************************************
Global Variables
***************************************************/
variable "location" {
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

variable "publisherName" {
  description = "The name of the publisher/company"
  type        = string
  default     = "Mela Peiris"
}

variable "publisherEmail" {
  description = "The email of the publisher/company; shows as administrator email in APIM"
  type        = string
  default     = "melan.peiris@justice.govt.nz"
}

variable "apimSkuName" {
  description = "String consisting of two parts separated by an underscore(_). The first part is the name, valid values include: Consumption, Developer, Basic, Standard and Premium. The second part is the capacity (e.g. the number of deployed units of the sku), which must be a positive integer (e.g. Developer_1)"
  type        = string
}