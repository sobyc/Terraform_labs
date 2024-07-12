variable "location" {
  type    = string
  default = "Central India"
}

variable "rgname-02" {
  type    = string
  default = "rg-ci-hub"
}

variable "vnet-hub" {
  type    = string
  default = "vnet-ci-hub"
}

variable "vnet-spoke" {
  type    = string
  default = "vnet-ci-spoke"
}


variable "dns_servers" {
  default = []
}


variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    Environment = "Prod"
    Resource    = "Vnet"
  }
}

variable "address_space-vnet-01" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

variable "address_space-vnet-02" {
  description = "The address space that is used by the virtual network."
  default     = "10.1.0.0/16"
}


variable "subnet_prefixes-vnet-01" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_names-vnet-01" {
  description = "A list of public subnets inside the vNet."
  default     = ["snet-ci-hub-mgmt-01", "snet-ci-hub-platform-01", "snet-ci-hub-connectivity-01"]
}

variable "subnet_prefixes-vnet-02" {
  description = "The address prefix to use for the subnet."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "subnet_names-vnet-02" {
  description = "A list of public subnets inside the vNet."
  default     = ["snet-ci-spoke-web-01", "snet-ci-spoke-app-01", "snet-ci-spoke-db-01"]
}
































