// Authenticate using Azure Cli login and selecting the current Subscription using "az set account --subscription XXX.XXX" command
// Create Resource group Module
// Create Virtual Network Module 
// Create Subnet Module
// Use count to create subnets which can be increased as per the address prefixes declared in variable or tfvars files
// Create one Hub and two Spoke vnet with three subnets in each vnet with name : Connectivity, Managment and Platform for Hub vnet
// and Web, App and Db subnets in two Spoke vnets 
// Do not call and use Resource Group and Vnet Modules in the main file. 
// Only Call subnet module, if we call resource group and vnet in main file, it will try to create duplicate resources 
// Initialise Lab10 folder, and add main file calling the Lab09 module as whole
// Create NSG module and create 2 NSG
// Create other NSG and attached to all subnets

module "subnet" {
  source = "./subnet"
}



