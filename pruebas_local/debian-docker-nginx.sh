#!/bin/bash

# Limpiar known_host
rm ~/.ssh/known_hosts*

# Resetear Docker.

./limpiar_docker.sh

# Cargar variables del archivo .env
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo "El archivo .env no existe. Por favor, créalo con las variables necesarias."
  exit 1
fi

# Construir la imagen Docker
docker build --build-arg ANSIBLE_USER_PASSWORD=${ANSIBLE_USER_PASSWORD} --build-arg ROOT_PASSWORD=${ROOT_PASSWORD} -t debian-ssh .

# Crear infraestructura con Terraform
cd terraform
terraform init
terraform apply -auto-approve
cd ..

# Ejecutar Ansible pasando las variables. Instalación nginx.
cd ansible
ansible-playbook -i inventory.ini ssh-nginx.yml -e "ansible_ssh_pass=$ANSIBLE_SSH_PASS" -e "ansible_become_pass=$ANSIBLE_SUDO_PASS"

# Verificar que Nginx esté funcionando
docker ps
NGINX_URL="http://localhost:8888"  # Cambia la URL si es necesario
MAX_RETRIES=5
RETRY_DELAY=5

for i in $(seq 1 $MAX_RETRIES); do
  echo "Intentando verificar Nginx (Intento $i/$MAX_RETRIES)..."
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $NGINX_URL)

  if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Nginx está funcionando correctamente (HTTP 200)."
    exit 0
  else
    echo "❌ Nginx no responde correctamente (HTTP $HTTP_STATUS). Reintentando en $RETRY_DELAY segundos..."
    sleep $RETRY_DELAY
  fi
done

echo "❌ No se pudo verificar Nginx después de $MAX_RETRIES intentos."
exit 1
