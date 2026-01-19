resource "azurerm_resource_group" "rg" {
  name     = "jenkins-bala-tf-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet"{
name = "tf-vnet"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet"{
name = "subnet"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "jenkinstfvm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCenZwtdV3l2wxvYzcQo2KXcMeulYi58hEl+j2zAUFOHXRyd7pmYSkZg7c77OEyx0M0pcgIoZrnoH65JG4hehh71EEXUkiXv5UH8V9EZ8WrtIXyj0nmD/AUEeRPh5psPDrgTBXmcegKiYiZoCXTXfV9Xy+z0DJ3lfdb5Z59qmEMW/n8W5jjk1hEYWt2EzsM565keKGC/HYhbypTEvKbT4xD0wf3kmM/Gbr5tsR6ha7V3eUHeSeCH2RKrl36KewnF/7B0i7f2d1wTTuYo4LDl4hagm92fP0+Pt5vSx6oRaSTuRKFO39lHOclh2LAYkwu/SoEYoxGpP109nBGxmYIu59+/5bL5B3AcLnDslgGyZybk7G6OFeMx27frwNhQUxsGjlCHT9Vkf8FQ2D1Q8onzvAXIHYlx+FhNKI0CWvLhzaDP3iMc1Kk7xFttiwn+wvP5/X35A4B6oPkw19qO7P0lYMYtsDcJPIhpqc8j4Q6mviBad/eg3oNy1k/1fu2St/XEv8= devops@devops-TUF-Gaming-FX505DY-FX505DY"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
