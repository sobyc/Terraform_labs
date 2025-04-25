variable "subnet_address_prefixes" {
  description = "The address prefixes for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/24"]

}
variable "subnet_names_vnet_hub" {
  description = "A list of public subnets inside the vNet1."
  type        = string
  default     = "GatewaySubnet"

}
