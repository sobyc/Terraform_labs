variable "subnets" {
  description = "List of subnet objects to create for a VNET. Each object must contain 'name' and 'address_prefix' (e.g. 10.0.1.0/24)."
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "virtual_network_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}
