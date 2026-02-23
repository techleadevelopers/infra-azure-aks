resource "azurerm_container_registry" "acr" {
  name                          = lower("acr${local.project_clean}${var.environment}")
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  sku                           = "Premium"
  admin_enabled                 = false
  public_network_access_enabled = false

  network_rule_set {
    default_action = "Deny"
  }

  tags = {
    Environment = var.environment
    Tier        = "Enterprise"
  }
}

resource "azurerm_private_endpoint" "acr_registry" {
  name                = "pe-acr-registry"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.privatelink_subnet.id

  private_service_connection {
    name                           = "acrlink-registry"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "acr-dns-registry"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr.id]
  }
}
