terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.1"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~>3.0"
    # }

  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  # The AzureRM Provider supports authenticating using via the Azure CLI, a Managed Identity
  # and a Service Principal. More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure

  # The features block allows changing the behaviour of the Azure Provider, more
  # information can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
  features {}
}

# ... Other resources ...
resource "azurerm_resource_group" "terraform" {
  name     = "terraform-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "terraform" {
  name                = "terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
}

resource "azurerm_subnet" "terraform" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.terraform.name
  virtual_network_name = azurerm_virtual_network.terraform.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "terraform_public_ip" {
  name                = "terraform-public-ip"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  allocation_method   = "Dynamic"
}
resource "azurerm_network_security_group" "terraform_nsg" {
  name                = "terraform-nsg"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
#   security_rule {
#     name                       = "web"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
}






resource "azurerm_network_interface" "terraform" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.terraform.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terraform_public_ip.id
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.terraform.id
  network_security_group_id = azurerm_network_security_group.terraform_nsg.id
}



variable "admin_username" {
  type        = string
  description = "Admin username for the Windows VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the Windows VM"
}


resource "azurerm_windows_virtual_machine" "terraform-machine" {
  name                  = var.az_name
  admin_username = var.admin_username
  admin_password = var.admin_password
  patch_mode = "AutomaticByPlatform"
  location              = azurerm_resource_group.terraform.location
  resource_group_name   = azurerm_resource_group.terraform.name
  network_interface_ids = [azurerm_network_interface.terraform.id]
  size                  = "Standard_B2s"  # This size has 2GB RAM
  #size                  = "Standard_D2_v3"  # This size has 2GB RAM
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

#   storage_data_disk {
#     name            = "datadisk1"
#     managed_disk_type = "Premium_LRS"
#     create_option   = "Empty"
#     disk_size_gb    = 50  # Size of the data disk
#   }


  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }


}

output "hello" {
  value = <<HELLO
  Hello, to login, go in remote desktop at: 
  ${azurerm_windows_virtual_machine.terraform-machine.public_ip_address}
  HELLO
}