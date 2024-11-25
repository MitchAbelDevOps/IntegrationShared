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

variable "serviceBusSku" {
  type        = string
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
}

variable "serviceBusAllowPublicAccess" {
  type        = bool
  description = "Boolean determining if the Service Bus public endpoint will accept traffic. Should be used in conjunction with a restricted list of IP's that can hit that public endpoint."
}

variable "servceBusIPRules" {
  type        = list(string)
  description = "List of IP's or CIDR ranges to allow to hit the Service Bus public endpoint."
}