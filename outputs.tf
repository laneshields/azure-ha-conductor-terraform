output "conductor1-ip" {
  value = azurerm_public_ip.conductor1.ip_address
}

output "conductor2-ip" {
  value = azurerm_public_ip.conductor2.ip_address
}
