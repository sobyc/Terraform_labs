/*variable "subnet_names_vnet_hub" {
  description = "A list of public subnets inside the vNet1."
  type        = list(string)
  default     = ["GatewaySubnet", "AzureFirewallSubnet", "snet-ci-prd-hub-identity-01", "snet-ci-prd-hub-mgmt-01", "snet-ci-prd-hub-connectivity-01"]
}


variable "subnet_address_prefixes" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}
variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    project     = "vnet-project"
  }
}*/

variable "subnet_names_vnet_hub" {
  description = "A list of public subnets inside the vNet1."
  type        = string

}
variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string

}
variable "address_prefixes" {
  description = "The address prefixes for the virtual network."
  type        = list(string)

}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string


}
