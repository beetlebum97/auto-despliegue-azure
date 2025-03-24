# auto-despliegue-azure

Automatización de despliegues en entornos Cloud. 

## Objetivos
- Crear infraestructura de forma automatizada en un proveedor de Cloud pública.
- Utilizar herramientas de gestión de la configuración para automatizar la instalación y configuración de servicios.
- Desplegar mediante un enfoque totalmente automatizado aplicaciones en forma de contenedor sobre el sistema operativo.
- Desplegar mediante un enfoque totalmente automatizado aplicaciones que hagan uso de almacenamiento persistente sobre una plataforma de orquestación de contenedores.

## Descripción
A continuación se describe la estructura del proyecto:
- Un repositorio de imágenes de contenedores sobre infraestructura de Microsoft Azure mediante el servicio **Azure Container Registry (ACR)**. 
- Una aplicación en forma de contenedor utilizando **Podman** sobre una máquina virtual en **Azure**.
- Un cluster de **Kubernetes** como servicio gestionado en **Microsoft Azure (AKS)**.
- Una **aplicación** con **almacenamiento persistente** sobre el cluster AKS. 

## Pruebas Local
Despliegue en entorno local de máquina virtual Debian con servidor Nginx.
- Docker.
- Terraform.
- Ansible.

