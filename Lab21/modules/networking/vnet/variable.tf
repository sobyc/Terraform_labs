variable "rg_names" {
  type    = list(string)
  default = ["rg-ci-hub-01", "rg-ci-finance-01", "rg-ci-hr-01"]
}



variable "location" {
  type    = string
  default = "Central India"
}

variable "region" {
  type    = string
  default = "ci"
}


variable "vnet_names" {
  type    = list(string)
  default = ["vnet-ci-hub-01", "vnet-ci-finance-01", "vnet-ci-hr-01"]
}

/*variable "vnet_name_spoke1" {
  type    = string
  default = "finance"
}*/

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
}



variable "rg_name_hub" {
  type    = string
  default = "rg-hub"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    cost_center = "finance"
  }
}


