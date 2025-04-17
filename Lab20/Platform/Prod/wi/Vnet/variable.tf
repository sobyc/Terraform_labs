variable "location" {
  type    = string
  default = "West India"
}

variable "rgname-02" {
  type    = string
  default = "rg-wi-hub"
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

variable "region" {
  type    = string
  default = "wi"
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
  default     = "10.20.0.0/16"
}

variable "address_space-vnet-02" {
  description = "The address space that is used by the virtual network."
  default     = "10.21.0.0/16"
}

variable "address_space-vnet-03" {
  description = "The address space that is used by the virtual network."
  default     = "10.22.0.0/16"
}































