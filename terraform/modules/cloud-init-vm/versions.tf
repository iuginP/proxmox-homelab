terraform {
  required_version = ">=0.14"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = ">=3.0.1-rc6"
    }
  }
}
