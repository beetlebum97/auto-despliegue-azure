#!/bin/bash

# [1] Eliminar todos los contenedores
docker rm -f $(docker ps -aq)

# [2] Eliminar todas las imágenes
docker rmi -f $(docker images -q)

# [3] Eliminar todos los volúmenes
docker volume rm $(docker volume ls -q)

# [4] Eliminar todas las redes personalizadas (excepto bridge, host y none)
docker network rm $(docker network ls -q)

# [5] Borrar datos y caché de Docker
docker system prune -af --volumes

# Verificación
echo "Verificando limpieza de Docker..."
docker ps -a
docker images -a
docker volume ls
docker network ls
echo "Docker ha sido limpiado completamente."
