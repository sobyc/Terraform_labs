locals {
  bu_name = basename(abspath(path.module))
}
# Enable below block when rules are populated for Central India

module "ci" {
  source  = ".//ci"
  bu_name = local.bu_name
}



# Enable below block when rules are populated for West India

module "wi" {
  source  = ".//wi"
  bu_name = local.bu_name
}


