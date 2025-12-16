variable "nsgs" {
  description = "List of NSGs to create. Each item is an object with: name, nsg_rules (list), associate_subnet_ids (list)."
  type = list(object({
    name = string
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
    associate_subnet_ids = list(string)
  }))
  default = []
}

variable "resource_group_name" {
  type        = string
  description = "Resource group in which to create the NSGs"
}

variable "location" {
  type        = string
  description = "Location for NSGs"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to NSGs"
  default     = {}
}
