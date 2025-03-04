# outputs.tf - Displays critical information after deployment

# Public IP Address Output
output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.ono_pip.ip_address
}

# SSH Connection Command Output
output "ssh_command" {
  description = "Command to SSH into the virtual machine"
  value       = "ssh onoadmin@${azurerm_public_ip.ono_pip.ip_address}"
}

# Resource Group Information
output "resource_group_name" {
  description = "Name of the resource group containing all resources"
  value       = azurerm_resource_group.ono_rg.name
}

output "resource_group_location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.ono_rg.location
}

# Virtual Machine Details
output "vm_name" {
  description = "Name of the deployed virtual machine"
  value       = azurerm_linux_virtual_machine.ono_vm.name
}

output "vm_size" {
  description = "Size specification of the virtual machine"
  value       = azurerm_linux_virtual_machine.ono_vm.size
}

# Network Security Group Reference
output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.ono_nsg.id
}

# Full VM Details (Marked sensitive to hide credentials)
output "full_vm_details" {
  description = "Complete virtual machine configuration details"
  value       = azurerm_linux_virtual_machine.ono_vm
  sensitive   = true
}