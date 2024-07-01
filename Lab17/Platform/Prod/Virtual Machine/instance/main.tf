data "azurerm_resource_group" "rg1" {
  name = "rg-ci-prd-hub-01"
}

output "rg-hub" {
  value = data.azurerm_resource_group.rg1.name
}

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


data "azurerm_subnet" "hub-mgmt" {
  name                 = "snet-ci-prd-hub-mgmt-01"
  virtual_network_name = "vnet-ci-prd-hub-01"
  resource_group_name  = "rg-ci-prd-hub-01"
}

output "subnet_id_hub_mgmt" {
  value = data.azurerm_subnet.hub-mgmt.id
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


resource "azurerm_public_ip" "vm0-pip" {
  name                = "vmciphmt01-pip"
  resource_group_name = data.azurerm_resource_group.rg1.name
  location            = data.azurerm_resource_group.rg1.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "vm-hub-mgmt-01" {
  name                = "nic-${var.prefix-hub-mgmt}-01"
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.hub-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm0-pip.id

  }
  
  depends_on = [ azurerm_public_ip.vm1-pip ]

}

output "nic-00-id" {
  value = azurerm_network_interface.vm-hub-mgmt-01.id
}

resource "azurerm_windows_virtual_machine" "vm-ci-hub-mgmt-01" {
  name                  = "vmciphmt01"
  resource_group_name   = data.azurerm_resource_group.rg1.name
  location              = data.azurerm_resource_group.rg1.location
  size                  = "Standard_D2s_v3"
  admin_username        = "adminuser"
  admin_password        = "Windows@111"
  network_interface_ids = [azurerm_network_interface.vm-hub-mgmt-01.id, ]


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
  
  depends_on = [ azurerm_network_interface.vm-hub-mgmt-01 ]


}


resource "azurerm_public_ip" "vm1-pip" {
  name                = "vmcipweb01-pip"
  resource_group_name = data.azurerm_resource_group.rg2.name
  location            = data.azurerm_resource_group.rg2.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "vm-spoke1-web-01" {
  name                = "nic-${var.prefix-spoke1-web}-01"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.spoke1-web.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.vm1-pip.id                   Removing this to have access to this VM only from the HUb Jump Server

  }

  depends_on = [ azurerm_public_ip.vm1-pip ]

}
output "nic-01-id" {
  value = azurerm_network_interface.vm-spoke1-web-01.id
}



resource "azurerm_windows_virtual_machine" "vm-ci-spoke1-web-01" {
  name                  = "vmcipweb01"
  resource_group_name   = data.azurerm_resource_group.rg2.name
  location              = data.azurerm_resource_group.rg2.location
  size                  = "Standard_D2s_v3"
  admin_username        = "adminuser"
  admin_password        = "Windows@111"
  network_interface_ids = [azurerm_network_interface.vm-spoke1-web-01.id, ]


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
  
  depends_on = [ azurerm_network_interface.vm-spoke1-web-01 ]


}


resource "azurerm_public_ip" "vm2-pip" {
  name                = "vmcipdb01-pip"
  resource_group_name = data.azurerm_resource_group.rg3.name
  location            = data.azurerm_resource_group.rg3.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}


resource "azurerm_network_interface" "vm-spoke2-db-01" {
  name                = "nic-${var.prefix-spoke2-db}-02"
  location            = data.azurerm_resource_group.rg3.location
  resource_group_name = data.azurerm_resource_group.rg3.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.spoke2-db.id
    private_ip_address_allocation = "Dynamic"
    //public_ip_address_id = azurerm_public_ip.vm2-pip.id                                 Removing this to have access to this VM only from the HUb Jump Server
  }
  
  depends_on = [ azurerm_public_ip.vm2-pip ]

}

output "nic-02-id" {
  value = azurerm_network_interface.vm-spoke2-db-01.id
}

resource "azurerm_windows_virtual_machine" "vm-ci-spoke2-db-01" {
  name                  = "vmcipdb01"
  resource_group_name   = data.azurerm_resource_group.rg3.name
  location              = data.azurerm_resource_group.rg3.location
  size                  = "Standard_D2s_v3"
  admin_username        = "adminuser"
  admin_password        = "Windows@111"
  network_interface_ids = [azurerm_network_interface.vm-spoke2-db-01.id, ]


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

  depends_on = [ azurerm_network_interface.vm-spoke2-db-01 ]


}







