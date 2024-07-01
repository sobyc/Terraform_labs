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
  default = "hub"
}

variable "env" {
  type    = string
  default = "prd"
}

variable "vnet-spoke" {
  type    = string
  default = "spoke"
}

variable "location" {
  type    = string
  default = "ci"
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

variable "address_space-vnet-03" {
  description = "The address space that is used by the virtual network."
  default     = "10.2.0.0/16"
}































