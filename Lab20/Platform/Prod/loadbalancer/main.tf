#Azure Generic Load Balancer Module

data "azurerm_resource_group" "rg2" {
  name = "rg-ci-prd-spoke-01"
}

output "rg-spoke1" {
  value = data.azurerm_resource_group.rg2.name
}
data "azurerm_resource_group" "rg3" {
  name = "rg-ci-prd-spoke-02"
}

output "rg-spoke2" {
  value = data.azurerm_resource_group.rg3.name
}


data "azurerm_subnet" "spoke1-web" {
  name                 = "snet-ci-prd-spoke1-web-01"
  virtual_network_name = "vnet-ci-prd-spoke-01"
  resource_group_name  = "rg-ci-prd-spoke-01"
}

output "subnet_id_spoke1_web" {
  value = data.azurerm_subnet.spoke1-web.id
}

data "azurerm_subnet" "spoke2-db" {
  name                 = "snet-ci-prd-spoke2-db-01"
  virtual_network_name = "vnet-ci-prd-spoke-02"
  resource_group_name  = "rg-ci-prd-spoke-02"
}

output "subnet_id_spoke2_db" {
  value = data.azurerm_subnet.spoke2-db.id
}


resource "azurerm_public_ip" "PublicIPForLB" {
  name                = "PublicIPForLB"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Basic"

}
resource "azurerm_lb" "etx_lb_spoke1" {
  name                = "lb-ci-ext-spoke1-01"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.PublicIPForLB.id
  }
}

resource "azurerm_lb_backend_address_pool" "bp-01" {
  loadbalancer_id = azurerm_lb.etx_lb_spoke1.id
  name            = "bp-01"
}

resource "azurerm_lb_probe" "hp-01" {
  loadbalancer_id = azurerm_lb.etx_lb_spoke1.id
  name            = "hp-01"
  port            = 32
}






resource "azurerm_lb" "int_lb_spoke2" {
  name                = "lb-ci-int-spoke2-01"
  location            = data.azurerm_resource_group.rg3.location
  resource_group_name = data.azurerm_resource_group.rg3.name
  sku                 = "Basic"


  frontend_ip_configuration {
    name      = "PrivateIPAddress"
    subnet_id = data.azurerm_subnet.spoke2-db.id

  }
}
resource "azurerm_lb_backend_address_pool" "bp-02" {
  loadbalancer_id = azurerm_lb.int_lb_spoke2.id
  name            = "bp-02"
}

resource "azurerm_lb_probe" "hp-02" {
  loadbalancer_id = azurerm_lb.int_lb_spoke2.id
  name            = "hp-02"
  port            = 32
}
