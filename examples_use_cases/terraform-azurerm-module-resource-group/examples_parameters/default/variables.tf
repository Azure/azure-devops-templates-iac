variable "location" {
  type        = string
  description = "(Required) Location where the resource group should be deployed."
}

variable "tags" {
  type        = map(string)
  description = "(Optionnal) Tags to be applied to resource group."
}
