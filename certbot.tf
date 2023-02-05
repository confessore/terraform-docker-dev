resource "docker_volume" "certbot_conf_volume" {
    name = "cerbot-conf"
}

resource "docker_volume" "certbot_www_volume" {
    name = "cerbot-www"
}

resource "docker_image" "certbot_image" {
  name = "certbot/certbot"
  keep_locally = true
}

resource "docker_container" "certbot_container" {
  image = docker_image.nginx_image.image_id
  name  = "certbot"
  hostname = "certbot"
  restart = "always"
  networks_advanced {
    name = docker_network.network.name
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
  command = [ "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'" ]
}