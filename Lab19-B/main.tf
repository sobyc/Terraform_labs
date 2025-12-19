// Authenticate using Azure Cli login and selecting the current Subscription using "az set account --subscription XXX.XXX" command
// Create Resource group Module
// Create Virtual Network Module 
// Create Subnet Module
// Use count to create subnets which can be increased as per the address prefixes declared in variable or tfvars files
// Create one Hub and two Spoke vnet with three subnets in each vnet with name : Connectivity, Managment and Platform for Hub vnet
// and Web, App and Db subnets in two Spoke vnets 
// Do not call and use Resource Group and Vnet Modules in the main file. 
// Only Call subnet module, if we call resource group and vnet in main file, it will try to create duplicate resources 
// Initialise Lab15 folder, and add main file calling the Lab15 module as whole
// Create NSG module and create 2 NSG
// Create web,app and db NSG in spoke1
// Create GatewaySubnet and create Virtual Network Gateway without root cert and vpn point to site configuration 
// Implement Platform folder and run module and code from Platform
// Remove NSG module initiation from Subnet main file, and keep it to run seperately like VNG module
// Remove RG module reference from NSG main file, use data argument to list the resource groups
// Create separate virtual machine module, create 2 Windows Virtual Machine in two seperate spoke, one in spoke1 and other in spoke 2
// Create one Virtual Machine Hub VNet, to check the connectivity
// Create Public IP resource and attached it the VM's to RDP directly only to Hub VM. Access spoke vm's from hub jump vm
// Create Route Table module and create 3 Route Table
// Create Prod Folder inside Platform Module, and update all files with env and location variables and data 
// VNet peering for Spoke1-Hub and Spoke2-hub
// Create Azure Firewall
// Create three virtual machine, one in each spokeie. Spoke1 , spoke2 and hub
// Check connectivity from spoke1 vm to spoke 2 vm via Hub Firewall
terraform {
  required_providers {
    azurerm = {

    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

}


module "Platform" {
  source = "./Platform"
}



