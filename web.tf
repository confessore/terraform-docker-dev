resource "docker_image" "web_image" {
  name = "web"
  keep_locally = true
}

resource "docker_container" "web_container" {
  image = docker_image.web_image.image_id
  name  = "web"
  hostname = "web"
  restart = "always"
  networks_advanced {
    name = docker_network.network.name
  }
  ports {
    internal = 3000
    external = 3000
  }
  remove_volumes = false
}