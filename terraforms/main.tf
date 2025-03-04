# main.tf
provider "azurerm" {
  features {}
  subscription_id = "967af8eb-711c-429b-bac4-33ebfa91742e"
}

# Configuration with Ireland (EU West) region and security best practices
resource "azurerm_resource_group" "ono_rg" {
  name     = "ono-server-rg"
  location = "West Europe"  # Azure's Ireland region is officially called "West Europe"
  tags = {
    Environment = "Dev"
    Owner       = "Ono"
  }
}

resource "azurerm_linux_virtual_machine" "ono_vm" {
  name                = "ono-web-vm"
  resource_group_name = azurerm_resource_group.ono_rg.name
  location            = azurerm_resource_group.ono_rg.location
  size                = "Standard_B1ms"  # Better performance than B1s
  admin_username      = "onoadmin"       # Change to your preferred username

  admin_ssh_key {
    username   = "onoadmin"
    public_key = file("~/.ssh/id_rsa.pub") # Path to your SSH public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"          # Ubuntu 22.04 LTS
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.ono_nic.id]

  tags = {
    Role = "WebServer"
  }
}

# Networking components
resource "azurerm_virtual_network" "ono_vnet" {
  name                = "ono-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.ono_rg.location
  resource_group_name = azurerm_resource_group.ono_rg.name
}

resource "azurerm_subnet" "ono_subnet" {
  name                 = "ono-subnet"
  resource_group_name  = azurerm_resource_group.ono_rg.name
  virtual_network_name = azurerm_virtual_network.ono_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_interface" "ono_nic" {
  name                = "ono-web-nic"
  location            = azurerm_resource_group.ono_rg.location
  resource_group_name = azurerm_resource_group.ono_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ono_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ono_pip.id
  }
}

resource "azurerm_public_ip" "ono_pip" {
  name                = "ono-web-ip"
  location            = azurerm_resource_group.ono_rg.location
  resource_group_name = azurerm_resource_group.ono_rg.name
  allocation_method   = "Static"  # Better for web servers than Dynamic
  sku                 = "Basic"

  tags = {
    Service = "WebServer"
  }
}

# Security Group with tighter rules
resource "azurerm_network_security_group" "ono_nsg" {
  name                = "ono-web-nsg"
  location            = azurerm_resource_group.ono_rg.location
  resource_group_name = azurerm_resource_group.ono_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "37.228.204.254/32"  # Restrict SSH to your IP
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Outputs for easy access
output "public_ip_address" {
  value = azurerm_public_ip.ono_pip.ip_address
}

output "ssh_connection_command" {
  value = "ssh onoadmin@${azurerm_public_ip.ono_pip.ip_address}"
}