#Azure Generic Route Table Module

data "azurerm_resource_group" "rg1" {
  name = "rg-ci-prd-hub-01"
}

output "rg1-id" {
  value = data.azurerm_resource_group.rg1.id
}


resource "azurerm_route_table" "rt-hub-firewall" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-hub}-firewall-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  route {
    name           = "route-internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "hub-firewall" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = "vnet-ci-prd-hub-01"
  resource_group_name  = "rg-ci-prd-hub-01"
}

output "subnet_id_identity" {
  value = data.azurerm_subnet.hub-firewall.id
}

resource "azurerm_subnet_route_table_association" "hub-firewall-subnet-rt" {
  subnet_id      = data.azurerm_subnet.hub-firewall.id
  route_table_id = azurerm_route_table.rt-hub-firewall.id
}





resource "azurerm_route_table" "rt-hub-mgmt" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-hub}-mgmt-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "hub-mgmt" {
  name                 = "snet-ci-prd-hub-mgmt-01"
  virtual_network_name = "vnet-ci-prd-hub-01"
  resource_group_name  = "rg-ci-prd-hub-01"
}

output "mgmt" {
  value = data.azurerm_subnet.hub-mgmt.id
}

resource "azurerm_subnet_route_table_association" "hub-mgmt-subnet-rt" {
  subnet_id      = data.azurerm_subnet.hub-mgmt.id
  route_table_id = azurerm_route_table.rt-hub-mgmt.id
}


data "azurerm_resource_group" "rg2" {
  name = "rg-ci-prd-spoke-01"
}

output "rg2-id" {
  value = data.azurerm_resource_group.rg2.id
}


resource "azurerm_route_table" "rt-spoke1-web" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke1}-web-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke1-web" {
  name                 = "snet-ci-prd-spoke1-web-01"
  virtual_network_name = "vnet-ci-prd-spoke-01"
  resource_group_name  = "rg-ci-prd-spoke-01"
}

output "subnet_id_spoke1_web" {
  value = data.azurerm_subnet.spoke1-web
}

resource "azurerm_subnet_route_table_association" "spoke1-web-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke1-web.id
  route_table_id = azurerm_route_table.rt-spoke1-web.id
}


resource "azurerm_route_table" "rt-spoke1-app" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke1}-app-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke1-app" {
  name                 = "snet-ci-prd-spoke1-app-01"
  virtual_network_name = "vnet-ci-prd-spoke-01"
  resource_group_name  = "rg-ci-prd-spoke-01"
}

output "subnet_id_spoke1_app" {
  value = data.azurerm_subnet.spoke1-app
}

resource "azurerm_subnet_route_table_association" "spoke1-app-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke1-app.id
  route_table_id = azurerm_route_table.rt-spoke1-app.id
}



resource "azurerm_route_table" "rt-spoke1-db" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke1}-db-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke1-db" {
  name                 = "snet-ci-prd-spoke1-db-01"
  virtual_network_name = "vnet-ci-prd-spoke-01"
  resource_group_name  = "rg-ci-prd-spoke-01"
}

output "subnet_id_spoke1_db" {
  value = data.azurerm_subnet.spoke1-db
}

resource "azurerm_subnet_route_table_association" "spoke1-db-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke1-db.id
  route_table_id = azurerm_route_table.rt-spoke1-db.id
}







data "azurerm_resource_group" "rg3" {
  name = "rg-ci-prd-spoke-02"
}

output "rg3-id" {
  value = data.azurerm_resource_group.rg3.id
}


resource "azurerm_route_table" "rt-spoke2-db" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke2}-db-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke2-db" {
  name                 = "snet-ci-prd-spoke2-db-01"
  virtual_network_name = "vnet-ci-prd-spoke-02"
  resource_group_name  = "rg-ci-prd-spoke-02"
}

output "subnet_id_spoke2_db" {
  value = data.azurerm_subnet.spoke2-db
}

resource "azurerm_subnet_route_table_association" "spoke2-db-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke2-db.id
  route_table_id = azurerm_route_table.rt-spoke2-db.id
}


resource "azurerm_route_table" "rt-spoke2-web" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke2}-web-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke2-web" {
  name                 = "snet-ci-prd-spoke2-web-01"
  virtual_network_name = "vnet-ci-prd-spoke-02"
  resource_group_name  = "rg-ci-prd-spoke-02"
}

output "subnet_id_spoke2_web" {
  value = data.azurerm_subnet.spoke2-web
}

resource "azurerm_subnet_route_table_association" "spoke2-web-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke2-web.id
  route_table_id = azurerm_route_table.rt-spoke2-web.id
}


resource "azurerm_route_table" "rt-spoke2-app" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-spoke2}-app-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "spoke2-app" {
  name                 = "snet-ci-prd-spoke2-app-01"
  virtual_network_name = "vnet-ci-prd-spoke-02"
  resource_group_name  = "rg-ci-prd-spoke-02"
}

output "subnet_id_spoke2_app" {
  value = data.azurerm_subnet.spoke2-app
}

resource "azurerm_subnet_route_table_association" "spoke2-app-subnet-rt" {
  subnet_id      = data.azurerm_subnet.spoke2-app.id
  route_table_id = azurerm_route_table.rt-spoke2-app.id
}





resource "azurerm_route_table" "rt-hub-identity" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-hub}-identity-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "hub-identity" {
  name                 = "snet-ci-prd-hub-identity-01"
  virtual_network_name = "vnet-ci-prd-hub-01"
  resource_group_name  = "rg-ci-prd-hub-01"
}

output "identity" {
  value = data.azurerm_subnet.hub-identity.id
}
resource "azurerm_subnet_route_table_association" "hub-identity-subnet-rt" {
  subnet_id      = data.azurerm_subnet.hub-identity.id
  route_table_id = azurerm_route_table.rt-hub-identity.id
}


resource "azurerm_route_table" "rt-hub-connectivity" {
  name                = "rt-${var.region}-${var.env}-${var.vnet-hub}-connectivity-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  route {
    name                   = "route1"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = "Production"
  }
}

data "azurerm_subnet" "hub-connectivity" {
  name                 = "snet-ci-prd-hub-connectivity-01"
  virtual_network_name = "vnet-ci-prd-hub-01"
  resource_group_name  = "rg-ci-prd-hub-01"
}

output "connectivity" {
  value = data.azurerm_subnet.hub-connectivity.id
}

resource "azurerm_subnet_route_table_association" "hub-connectivity-subnet-rt" {
  subnet_id      = data.azurerm_subnet.hub-connectivity.id
  route_table_id = azurerm_route_table.rt-hub-connectivity.id
}



/*



resource "azurerm_network_security_group" "nsg-hub-connectivity" {
  name                = "nsg-${var.env}-${var.vnet-hub}-connectivity-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "hub-connectivity" {
  name                 = "snet-ci-hub-connectivity-01"
  virtual_network_name = "vnet-ci-hub-01"
  resource_group_name  = "rg-ci-hub-01"
}

output "subnet_id_connectivity" {
  value = data.azurerm_subnet.hub-connectivity.id
}


resource "azurerm_subnet_network_security_group_association" "hub-connectivity-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.hub-connectivity.id
  network_security_group_id = azurerm_network_security_group.nsg-hub-connectivity.id
}





data "azurerm_resource_group" "rg2" {
  name = "rg-ci-spoke-01"
}

output "rg-spoke1" {
  value = data.azurerm_resource_group.rg2.id
}

resource "azurerm_network_security_group" "nsg-spoke1-web" {
  name                = "nsg-${var.env}-${var.vnet-spoke1}-web-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke1-web" {
  name                 = "snet-ci-spoke1-web-01"
  virtual_network_name = "vnet-ci-spoke-01"
  resource_group_name  = "rg-ci-spoke-01"
}

output "subnet_id_spoke1_web" {
  value = data.azurerm_subnet.spoke1-web.id
}


resource "azurerm_subnet_network_security_group_association" "spoke1-web-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke1-web.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke1-web.id
}






resource "azurerm_network_security_group" "nsg-spoke1-app" {
  name                = "nsg-${var.env}-${var.vnet-spoke1}-app-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke1-app" {
  name                 = "snet-ci-spoke1-app-01"
  virtual_network_name = "vnet-ci-spoke-01"
  resource_group_name  = "rg-ci-spoke-01"
}

output "subnet_id_spoke1_app" {
  value = data.azurerm_subnet.spoke1-app.id
}


resource "azurerm_subnet_network_security_group_association" "spoke1-app-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke1-app.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke1-app.id
}


resource "azurerm_network_security_group" "nsg-spoke1-db" {
  name                = "nsg-${var.env}-${var.vnet-spoke1}-db-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke1-db" {
  name                 = "snet-ci-spoke1-db-01"
  virtual_network_name = "vnet-ci-spoke-01"
  resource_group_name  = "rg-ci-spoke-01"
}

output "subnet_id_spoke1_db" {
  value = data.azurerm_subnet.spoke1-db.id
}

resource "azurerm_subnet_network_security_group_association" "spoke1-db-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke1-db.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke1-db.id
}

data "azurerm_resource_group" "rg3" {
  name = "rg-ci-spoke-02"
}

output "rg-spoke2" {
  value = data.azurerm_resource_group.rg3.id
}

resource "azurerm_network_security_group" "nsg-spoke2-web" {
  name                = "nsg-${var.env}-${var.vnet-spoke2}-web-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke2-web" {
  name                 = "snet-ci-spoke2-web-01"
  virtual_network_name = "vnet-ci-spoke-02"
  resource_group_name  = "rg-ci-spoke-02"
}

output "subnet_id_spoke2_web" {
  value = data.azurerm_subnet.spoke2-web.id
}


resource "azurerm_subnet_network_security_group_association" "spoke2-web-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke2-web.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke2-web.id
}






resource "azurerm_network_security_group" "nsg-spoke2-app" {
  name                = "nsg-${var.env}-${var.vnet-spoke2}-app-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke2-app" {
  name                 = "snet-ci-spoke2-app-01"
  virtual_network_name = "vnet-ci-spoke-02"
  resource_group_name  = "rg-ci-spoke-02"
}

output "subnet_id_spoke2_app" {
  value = data.azurerm_subnet.spoke2-app.id
}


resource "azurerm_subnet_network_security_group_association" "spoke2-app-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke2-app.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke2-app.id
}


resource "azurerm_network_security_group" "nsg-spoke2-db" {
  name                = "nsg-${var.env}-${var.vnet-spoke2}-db-01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }

}

data "azurerm_subnet" "spoke2-db" {
  name                 = "snet-ci-spoke2-db-01"
  virtual_network_name = "vnet-ci-spoke-02"
  resource_group_name  = "rg-ci-spoke-02"
}

output "subnet_id_spoke2_db" {
  value = data.azurerm_subnet.spoke2-db.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2-db-subnet-nsg" {
  subnet_id                 = data.azurerm_subnet.spoke2-db.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke2-db.id
}


*/
