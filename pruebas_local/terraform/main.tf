terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "debian_ssh" {
  name = "debian-ssh"
}

resource "docker_container" "debian_container" {
  name  = "debian-ssh-container"
  image = docker_image.debian_ssh.image_id  # Usa image_id en lugar de latest

  ports {
    internal = 22
    external = 2222
  }

  ports {
    internal = 80
    external = 8888
  }
}
