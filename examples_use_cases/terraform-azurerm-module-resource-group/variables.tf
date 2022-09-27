variable "enabled" {
  description = "(Optional) Define if the use of the module is enabled or not. Great for test purposes."
  type        = bool
  default     = true
}

variable "name" {
  description = "(Required) Name of the resource group to deploy."
  type        = string

  validation {
    condition     = var.name == "" || length(var.name) >= 1 && length(var.name) <= 90 && can(regex("^[a-zA-Z0-9-._\\(\\)]+[a-zA-Z0-9-_\\(\\)]$", var.name))
    error_message = "Invalid name per Azure resource naming convention."
  }
}

variable "location" {
  description = "(Required) Region where the resource group will be deployed on."
  type        = string
}

variable "tags" {
  description = "(Optional) Tags to be assigned to the Resource Group."
  type        = map(string)
  default     = {}
}
