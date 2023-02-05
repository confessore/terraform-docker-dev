resource "docker_volume" "nginx_volume" {
  name = "nginx"
}

resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "nginx"
  hostname = "nginx"
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
  mounts {
    type = "volume"
    target = "/etc/nginx/conf.d"
    source = "nginx"
  }
  mounts {
    type = "volume"
    target = "/etc/letsencrypt"
    source = "certbot-conf"
  }
  mounts {
    type = "volume"
    target = "/var/www/certbot"
    source = "certbot-www"
  }
  remove_volumes = false
  command = [ "/bin/sh -c 'while :; do sleep 6h & wait $${!}; nginx -s reload; done & nginx -g \"daemon off;\"'" ]
}