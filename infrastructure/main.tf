terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "ssh_public" {
  type = string
}

resource "hcloud_ssh_key" "name" {
  name = "lecture_key"
  public_key = var.ssh_public
}

resource "hcloud_server" "server" {
  name = "server"

  server_type = "cpx21"
  location = "hel1" # Helsinki
  image = "debian-12"

  ssh_keys = [
    hcloud_ssh_key.name.id
  ]
}
