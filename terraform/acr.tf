# acr.tf

# Crear un Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "dvrAcrRegistry"  # Nombre del ACR (debe ser único a nivel global)
  resource_group_name = azurerm_resource_group.rg.name  # Grupo de recursos
  location            = azurerm_resource_group.rg.location  # Ubicación
  sku                 = "Basic"  # SKU del ACR (Basic, Standard, Premium)
  admin_enabled       = true  # Habilitar el usuario administrador

  tags = {
    environment = "casopractico2"  # Etiqueta requerida
  }
}
