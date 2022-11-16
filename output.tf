output "server_ip" {
  value = azurerm_linux_virtual_machine.modulo-linux-virtual-machine.public_ip_address
}