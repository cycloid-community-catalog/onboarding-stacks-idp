resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rule" {
  name             = "AllowAllAzureIPs"
  server_id        = azurerm_postgresql_flexible_server.postgresql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
} 