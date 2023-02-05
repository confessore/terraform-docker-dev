resource "docker_volume" "mongo_db_volume" {
    name = "mongo-db"
}

resource "docker_volume" "mongo_configdb_volume" {
    name = "mongo-configdb"
}

resource "docker_image" "mongo_image" {
  name = "mongo:latest"
  keep_locally = true
}

resource "docker_container" "mongo_container" {
  image = docker_image.mongo_image.image_id
  name  = "mongo"
  restart = "always"
  networks_advanced {
    name = docker_network.network.name
  }
  ports {
    internal = 27017
    external = 27017
  }
  mounts {
    type = "volume"
    target = "/data/db"
    source = "mongo-db"
  }
  mounts {
    type = "volume"
    target = "/data/configdb"
    source = "mongo-configdb"
  }
  env = [
    "MONGO_INITDB_ROOT_USERNAME=username",
    "MONGO_INITDB_ROOT_PASSWORD=password"
  ]
  remove_volumes = false
}