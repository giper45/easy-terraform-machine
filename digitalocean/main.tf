terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "terraform-machine" {
image  = var.do_image
  name   = var.do_name
  region = "nyc1"
  size   = var.do_size
  ssh_keys =  [var.do_key_id]

}

output "hello" {
    value = "Hello, to login: ssh root@${digitalocean_droplet.terraform-machine.ipv4_address}"
}
