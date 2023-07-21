// Authenticate using Azure Cli login and selecting the current Subscription using "az set account --subscription XXX.XXX" command
// Create Resource group Module
// Create Virtual Network Module 
// Create Subnet Module
// Use count to create subnets which can be increased as per the address prefixes declared in variable or tfvars files
// Create one Hub and one Spoke vnet with three subnets in each vnet with name : Connectivity, Managment and Platform for Hub vnet
#  and Web, App and Db subnets in Spoke vnet 
// Do not call and use Resource Group and Vnet Modules in the main file. 
// Only Call subnet module, if we call resource group and vnet in main file, it will try to create duplicate resources 


module "subnet" {
  source = "./Subnet"
}
