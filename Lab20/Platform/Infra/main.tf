
module "resourcegroup" {
  source = ".//Resource Group"
}

module "firewallpolicy" {
  source = ".//firewallpolicy"
}

module "firewall" {
  source = ".//firewall"

  depends_on = [module.resourcegroup]

}
