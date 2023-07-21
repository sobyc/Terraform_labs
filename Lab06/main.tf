// Authenticate using service principal, create provider file and use variable to use secret
// Create Resource group Module
// Create Virtual Network Module 
// Create Subnet as seperate resource in vnet module
// Use count to create subnets which can be increased as per the address prefixes declared in variable or tfvars files



module "resource_group" {
  source = "./Resource Group"
}

module "vnet" {
  source = "./Vnet"
}
