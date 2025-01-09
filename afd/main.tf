
resource "azurerm_resource_group" "rg-01" {
  name = "rg-ci-p-afd-01"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet-01" {
  name                = "vnet-ci-p-afddemo-01"
  address_space       = ["11.0.0.0/16"]
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  depends_on = [ azurerm_resource_group.rg-01 ]
}

resource "azurerm_subnet" "snet-01" {
  name                 = "vnet-ci-p-afddemo-web-01"
  resource_group_name  = azurerm_resource_group.rg-01.name
  virtual_network_name = azurerm_virtual_network.vnet-01.name
  address_prefixes     = ["11.0.2.0/24"]

  depends_on = [ azurerm_resource_group.rg-01, azurerm_virtual_network.vnet-01 ]
}

resource "azurerm_public_ip" "pip-vm-01" {
  name                = "afd-vm-pip-01"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  allocation_method   = "Static"
  domain_name_label = "vm-ci-p-afd-01"

  depends_on = [ azurerm_resource_group.rg-01 ]
}


resource "azurerm_public_ip" "pip-vm-02" {
  name                = "afd-vm-pip-02"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  allocation_method   = "Static"

  depends_on = [ azurerm_resource_group.rg-01 ]
}
resource "azurerm_network_interface" "nic-01" {
  name                = "nic-ci-p-afddemo-vm-01"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-vm-01.id
  }

  depends_on = [ azurerm_subnet.snet-01 ]
}


resource "azurerm_network_security_group" "nsg-01" {
  name                = "nsg-ci-p-adfdemo-01"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  security_rule {
    name                       = "rdp-01"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389,80,443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "snet-nsg-01" {
  subnet_id                 = azurerm_subnet.snet-01.id
  network_security_group_id = azurerm_network_security_group.nsg-01.id
}





resource "azurerm_windows_virtual_machine" "vm-01" {
  name                = "vm-ci-p-afd-01"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Windows@12345"
  network_interface_ids = [
    azurerm_network_interface.nic-01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [ azurerm_network_interface.nic-01 ]
}


resource "azurerm_network_interface" "nic-02" {
  name                = "nic-ci-p-afddemo-vm-02"
  location            = azurerm_resource_group.rg-01.location
  resource_group_name = azurerm_resource_group.rg-01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip-vm-02.id
  }

  depends_on = [ azurerm_subnet.snet-01 ]
}

resource "azurerm_windows_virtual_machine" "vm-02" {
  name                = "vm-ci-p-afd-02"
  resource_group_name = azurerm_resource_group.rg-01.name
  location            = azurerm_resource_group.rg-01.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Windows@12345"
  network_interface_ids = [
    azurerm_network_interface.nic-02.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  depends_on = [ azurerm_network_interface.nic-02 ]
}


/*
resource "azurerm_frontdoor" "afd-01" {
  name                = "afd-ci-p-01"
  resource_group_name = azurerm_resource_group.rg-01.name

  routing_rule {
    name               = "RoutingRule1"
    accepted_protocols = ["Http"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["FrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "BackendBing"
    }
  }

  backend_pool_load_balancing {
    name = "LoadBalancingSettings1"
  }

  backend_pool_health_probe {
    name = "HealthProbeSetting1"
  }

  backend_pool {
    name = "BackendBing"
    backend {
      host_header = "www.bing.com"
      address     = "www.bing.com"
      http_port   = 80
      https_port  = 443
    }

    backend {
      http_port = 80
      https_port = 443
      address = azurerm_network_interface.nic-01
      host_header = azurerm_network_interface.nic-01

    }


    load_balancing_name = "LoadBalancingSettings1"
    health_probe_name   = "HealthProbeSetting1"
  }

  frontend_endpoint {
    name      = "FrontendEndpoint1"
    host_name = "afd-ci-p-01.azurefd.net"
  }
}
*/







