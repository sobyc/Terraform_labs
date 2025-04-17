

variable "subnet_prefixes-vnet-01" {
  description = "The address prefix to use for the subnet."
  default     = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24", "10.20.4.0/24"]
}

variable "subnet_names-vnet-hub" {
  description = "A list of public subnets inside the vNet1."
  default     = ["GatewaySubnet", "AzureFirewallSubnet", "snet-wi-prd-hub-identity-01", "snet-wi-prd-hub-mgmt-01", "snet-wi-prd-hub-connectivity-01"]
}

variable "subnet_prefixes-vnet-02" {
  description = "The address prefix to use for the subnet."
  default     = ["10.21.1.0/24", "10.21.2.0/24", "10.21.3.0/24"]
}

variable "subnet_names-vnet-spoke1" {
  description = "A list of public subnets inside the vNet2."
  default     = ["snet-wi-prd-spoke1-web-01", "snet-wi-prd-spoke1-app-01", "snet-wi-prd-spoke1-db-01"]
}

variable "subnet_prefixes-vnet-03" {
  description = "The address prefix to use for the subnet."
  default     = ["10.22.1.0/24", "10.22.2.0/24", "10.22.3.0/24"]
}


variable "subnet_names-vnet-spoke2" {
  description = "A list of public subnets inside the vNet3."
  default     = ["snet-wi-prd-spoke2-web-01", "snet-wi-prd-spoke2-app-01", "snet-wi-prd-spoke2-db-01"]
}
