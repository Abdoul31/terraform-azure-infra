terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
  
  subscription_id = "9798ff17-1de5-4d3e-87dd-30683bcbe1c5"
  tenant_id       = "730eae8f-15ce-415e-b01c-390a85253bf3"
  client_id       = "87eaaf56-6482-4cc9-ba5c-02221f72b4e5"
 
  
}
 

resource "azurerm_resource_group" "my-azure-rsc" {
  name     = "my-azure-rsc-vm-serverweb"
  location = "francecentral"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-serverweb"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.my-azure-rsc.location
  resource_group_name = azurerm_resource_group.my-azure-rsc.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-serverweb"
  resource_group_name  = azurerm_resource_group.my-azure-rsc.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-serverweb"
  location            = azurerm_resource_group.my-azure-rsc.location
  resource_group_name = azurerm_resource_group.my-azure-rsc.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-server-web"
  resource_group_name   = azurerm_resource_group.my-azure-rsc.name
  location              = azurerm_resource_group.my-azure-rsc.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/DARADJI/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = filebase64("install-tomcat.sh")
}

resource "azurerm_storage_account" "storage" {
  name                     = "storageserverweb123"
  resource_group_name      = azurerm_resource_group.my-azure-rsc.name
  location                 = azurerm_resource_group.my-azure-rsc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Ajout storage azure blob
/* resource "azurerm_storage_container" "blob_container" {
  name                  = "my-container"
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = "private" # ou "blob" si tu veux public
} */
