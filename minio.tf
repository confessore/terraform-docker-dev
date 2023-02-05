resource "docker_volume" "minio_volume" {
  name = "minio"
}

resource "docker_image" "minio_image" {
  name = "minio/minio:latest"
  keep_locally = true
}

resource "docker_container" "minio_container" {
  image = docker_image.minio_image.image_id
  name  = "minio"
  restart = "always"
  networks_advanced {
    name = docker_network.network.name
  }
  ports {
    internal = 9000
    external = 9000
  }
  ports {
    internal = 9090
    external = 9090
  }
  mounts {
    type = "volume"
    target = "/data"
    source = "minio"
  }
  env = [
   "MINIO_ROOT_USER=username",
   "MINIO_ROOT_PASSWORD=password"
  ]
  command = ["server", "/data", "--console-address", ":9090"]
  remove_volumes = false
}