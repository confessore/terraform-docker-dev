resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "nginx"
  restart = "always"
  networks_advanced {
    name = docker_network.network.name
  }
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }
  remove_volumes = false
}