# aks.tf

# Crear un clúster de Kubernetes (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "dvrAksCluster"  # Nombre del clúster
  location            = azurerm_resource_group.rg.location  # Ubicación
  resource_group_name = azurerm_resource_group.rg.name  # Grupo de recursos
  dns_prefix          = "dvrAksCluster"  # Prefijo DNS

  sku_tier = "Standard"  # SKU del clúster ["Free" "Standard" "Premium"]

  default_node_pool {
    name       = "default"  # Nombre del grupo de nodos
    node_count = 1  # Número de nodos
    vm_size    = "Standard_B2s"  # Tamaño de la VM
  }

  identity {
    type = "SystemAssigned"  # Identidad gestionada por el sistema
  }

  role_based_access_control_enabled = true  # Habilitar RBAC

  tags = {
    environment = "casopractico2"  # Etiqueta requerida
  }
}

# Asignar permisos de ACR Pull al clúster de AKS
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id  # Identidad del kubelet del AKS
  role_definition_name = "AcrPull"  # Rol para descargar imágenes desde el ACR
  scope                = azurerm_container_registry.acr.id  # ID del ACR
}
