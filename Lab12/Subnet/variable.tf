

variable "subnet_prefixes-vnet-01" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.0.0/24"]
}

variable "subnet_names-vnet-hub" {
  description = "A list of public subnets inside the vNet."
  default     = ["snet-ci-hub-identity-01", "snet-ci-hub-mgmt-01", "snet-ci-hub-connectivity-01", "GatewaySubnet"]
}

variable "subnet_prefixes-vnet-02" {
  description = "The address prefix to use for the subnet."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "subnet_names-vnet-spoke" {
  description = "A list of public subnets inside the vNet."
  default     = ["snet-ci-spoke-web-01", "snet-ci-spoke-app-01", "snet-ci-spoke-db-01"]
}

variable "subnet_prefixes-vnet-03" {
  description = "The address prefix to use for the subnet."
  default     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
}
