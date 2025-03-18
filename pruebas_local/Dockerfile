FROM debian:latest

# Instalar SSH, Python y herramientas básicas
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3

# Crear un usuario para Ansible con una contraseña conocida
ARG ANSIBLE_USER_PASSWORD
RUN useradd -m -s /bin/bash ansible-user && \
    echo "ansible-user:${ANSIBLE_USER_PASSWORD}" | chpasswd && \
    usermod -aG sudo ansible-user

# Configurar SSH
RUN mkdir /var/run/sshd
ARG ROOT_PASSWORD
RUN echo "root:${ROOT_PASSWORD}" | chpasswd

# Deshabilitar el acceso SSH como root
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Habilitar autenticación por contraseña (PasswordAuthentication)
RUN if grep -q "^PasswordAuthentication" /etc/ssh/sshd_config; then \
        sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config; \
    else \
        echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
    fi

# Exponer el puerto SSH
EXPOSE 22

# Iniciar SSH al arrancar
CMD ["/usr/sbin/sshd", "-D"]
