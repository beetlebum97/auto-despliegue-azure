# network.tf

# Crear una red virtual (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "dvr-vnet" # Nombre de la red virtual
  address_space       = ["10.0.0.0/16"] # Espacio de direcciones de la red virtual
  location            = azurerm_resource_group.rg.location # Usa la ubicación del grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name # Asocia la red virtual al grupo de recursos
  tags = {
    environment = "casopractico2"
  }
}

# Crear una subred dentro de la red virtual
resource "azurerm_subnet" "subnet" {
  name                 = "dvr-subnet" # Nombre de la subred
  resource_group_name  = azurerm_resource_group.rg.name # Grupo de recursos
  virtual_network_name = azurerm_virtual_network.vnet.name # Asocia la subred a la red virtual
  address_prefixes     = ["10.0.1.0/24"] # Espacio de direcciones de la subred
}

# Crear un grupo de seguridad de red (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "dvr-nsg" # Nombre del NSG
  location            = azurerm_resource_group.rg.location # Ubicación del grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name # Grupo de recursos
  tags = {
    environment = "casopractico2"
  }
}

# Regla para permitir SSH (puerto 22)
resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 1001 # Prioridad de la regla (debe ser única)
  direction                   = "Inbound" # Dirección del tráfico (entrante)
  access                      = "Allow" # Permitir el tráfico
  protocol                    = "Tcp" # Protocolo TCP
  source_port_range           = "*" # Puerto de origen (cualquiera)
  destination_port_range      = "22" # Puerto de destino (SSH)
  source_address_prefix       = "*" # Dirección IP de origen (cualquiera)
  destination_address_prefix  = "*" # Dirección IP de destino (cualquiera)
  resource_group_name         = azurerm_resource_group.rg.name # Grupo de recursos
  network_security_group_name = azurerm_network_security_group.nsg.name # NSG asociado
}

# Regla para permitir HTTP (puerto 80)
resource "azurerm_network_security_rule" "http" {
  name                        = "allow-http"
  priority                    = 1002 # Prioridad de la regla (debe ser única)
  direction                   = "Inbound" # Dirección del tráfico (entrante)
  access                      = "Allow" # Permitir el tráfico
  protocol                    = "Tcp" # Protocolo TCP
  source_port_range           = "*" # Puerto de origen (cualquiera)
  destination_port_range      = "80" # Puerto de destino (HTTP)
  source_address_prefix       = "*" # Dirección IP de origen (cualquiera)
  destination_address_prefix  = "*" # Dirección IP de destino (cualquiera)
  resource_group_name         = azurerm_resource_group.rg.name # Grupo de recursos
  network_security_group_name = azurerm_network_security_group.nsg.name # NSG asociado
}

# Regla para permitir HTTPS (puerto 443)
resource "azurerm_network_security_rule" "https" {
  name                        = "allow-https"
  priority                    = 1003 # Prioridad de la regla (debe ser única)
  direction                   = "Inbound" # Dirección del tráfico (entrante)
  access                      = "Allow" # Permitir el tráfico
  protocol                    = "Tcp" # Protocolo TCP
  source_port_range           = "*" # Puerto de origen (cualquiera)
  destination_port_range      = "443" # Puerto de destino (HTTPS)
  source_address_prefix       = "*" # Dirección IP de origen (cualquiera)
  destination_address_prefix  = "*" # Dirección IP de destino (cualquiera)
  resource_group_name         = azurerm_resource_group.rg.name # Grupo de recursos
  network_security_group_name = azurerm_network_security_group.nsg.name # NSG asociado
}

# Crear una IP pública
resource "azurerm_public_ip" "public_ip" {
  name                = "dvr-public-ip" # Nombre de la IP pública
  location            = azurerm_resource_group.rg.location # Ubicación del grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name # Grupo de recursos
  allocation_method   = "Static" # Asignación estática (puede ser "Dynamic" si prefieres)
  sku                 = "Standard" # SKU de la IP pública (Standard o Basic)
  tags = {
    environment = "casopractico2"
  }
}

# Crear una interfaz de red (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "dvr-nic" # Nombre de la NIC
  location            = azurerm_resource_group.rg.location # Ubicación del grupo de recursos
  resource_group_name = azurerm_resource_group.rg.name # Grupo de recursos
  tags = {
    environment = "casopractico2"
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id # Asocia la NIC a la subred
    private_ip_address_allocation = "Dynamic" # Asignación dinámica de IP privada
    public_ip_address_id          = azurerm_public_ip.public_ip.id # Asocia la IP pública
  }
}

# Asociar el NSG a la NIC
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id # ID de la NIC
  network_security_group_id = azurerm_network_security_group.nsg.id # ID del NSG
}
