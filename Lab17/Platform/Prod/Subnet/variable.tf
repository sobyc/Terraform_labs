

variable "subnet_prefixes-vnet-01" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.0.0/24","10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24" ]
}

variable "subnet_names-vnet-hub" {
  description = "A list of public subnets inside the vNet1."
  default     = ["GatewaySubnet","AzureFirewallSubnet","snet-ci-prd-hub-identity-01", "snet-ci-prd-hub-mgmt-01", "snet-ci-prd-hub-connectivity-01"]
}

variable "subnet_prefixes-vnet-02" {
  description = "The address prefix to use for the subnet."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "subnet_names-vnet-spoke1" {
  description = "A list of public subnets inside the vNet2."
  default     = ["snet-ci-prd-spoke1-web-01", "snet-ci-prd-spoke1-app-01", "snet-ci-prd-spoke1-db-01"]
}

variable "subnet_prefixes-vnet-03" {
  description = "The address prefix to use for the subnet."
  default     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}


variable "subnet_names-vnet-spoke2" {
  description = "A list of public subnets inside the vNet3."
  default     = ["snet-ci-prd-spoke2-web-01", "snet-ci-prd-spoke2-app-01", "snet-ci-prd-spoke2-db-01"]
}
