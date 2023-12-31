data "azurerm_resource_group" "rg2" {
  name = "rg-ci-spoke-01"
}

output "rg-spoke1" {
  value = data.azurerm_resource_group.rg2.name
}


data "azurerm_subnet" "spoke1-web" {
  name                 = "snet-ci-spoke1-web-01"
  virtual_network_name = "vnet-ci-spoke-01"
  resource_group_name  = "rg-ci-spoke-01"
}

output "subnet_id_spoke1_web" {
  value = data.azurerm_subnet.spoke1-web.id
}


resource "azurerm_network_interface" "vm-spoke1-web-01" {
  name                = "nic-${var.prefix}-01"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.spoke1-web.id
    private_ip_address_allocation = "Dynamic"
  }
}
output "nic-id" {
  value = azurerm_network_interface.vm-spoke1-web-01.id
}



resource "azurerm_windows_virtual_machine" "vm-ci-spoke1-web-01" {
  name                  = "vmciweb01"
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
}





resource "azurerm_network_interface" "vm-spoke1-web-02" {
  name                = "nic-${var.prefix}-02"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.azurerm_subnet.spoke1-web.id
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_windows_virtual_machine" "vm-ci-spoke1-web-02" {
  name                  = "vmciweb02"
  resource_group_name   = data.azurerm_resource_group.rg2.name
  location              = data.azurerm_resource_group.rg2.location
  size                  = "Standard_D2s_v3"
  admin_username        = "adminuser"
  admin_password        = "Windows@111"
  network_interface_ids = [azurerm_network_interface.vm-spoke1-web-02.id, ]


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
}
