variable "vnet_configs" {
  type = list(object({
    name                = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
  }))
}
