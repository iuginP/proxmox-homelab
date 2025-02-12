# Proxmox Provider
# ---
# Initial Provider Configuration for Proxmox

terraform {
  required_version = ">= 0.15"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    bgpproxmox = {
      source = "bpg/proxmox"
      version = "0.71.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = var.proxmox_tls_insecure  # <-- (Optional) Change to true if you are using self-signed certificates
}

provider "bgpproxmox" {
  endpoint = var.proxmox_api_url
  username = var.proxmox_admin_username
  password = var.proxmox_admin_password
  insecure = var.proxmox_tls_insecure

  ssh {
    agent = true
  }
}
