# vm.tf

# Generar un par de claves SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Guardar la clave privada en un archivo local
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/id_rsa"
  file_permission = "0600" # Permisos para el archivo de clave privada
}

# Crear la máquina virtual
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "dvr-vm" # Nombre de la VM
  resource_group_name = azurerm_resource_group.rg.name # Grupo de recursos
  location            = azurerm_resource_group.rg.location # Ubicación
  size                = "Standard_B1s" # Tamaño de la VM (económico)
  admin_username      = "azureuser" # Nombre de usuario administrador
  tags = {
    environment = "casopractico2"
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id # Asocia la NIC a la VM
  ]

  admin_ssh_key {
    username   = "azureuser" # Nombre de usuario para SSH
    public_key = tls_private_key.ssh_key.public_key_openssh # Usa la clave pública generada
  }

  # Configuración del disco del sistema operativo
  os_disk {
    caching              = "ReadWrite" # Almacenamiento en caché
    storage_account_type = "Standard_LRS" # Tipo de almacenamiento (estándar)
  }

  # Imagen del sistema operativo (Ubuntu 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
