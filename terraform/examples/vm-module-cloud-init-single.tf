terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~>2.0"
    }
  }
}

provider "proxmox" {
  # Set PM_API_URL, PM_USER, PM_PASS environment variables
  pm_tls_insecure = true
}

module "ubuntu_vm" {
  source = "modules/cloud-init-vm"

  vm_name        = "ubuntu-single-vm"
  vm_id          = 900
  vm_description = "Example Ubuntu Cloud-Init VM built with Terraform"
  vm_count       = 2

  template_clone      = "ubuntu-20.04-cloudimg"
  template_full_clone = true

  # Must not be any existing user like 'admin' or 'ubuntu'
  admin_username = "localadmin"
  admin_password = "p@sswordz"
  # Uncomment and populate if the template does not allow SSH password authentication.
  # admin_public_ssh_keys = []


  # Uncomment for Static IP on the Primary NIC. DHCP is default.
  # primary_network_cidr_address = "10.0.0.246/24"
  # primary_network_gateway      = "10.0.0.1"

  primary_network_cidr_address = [
    "192.168.1.101/24",
    "192.168.1.102/24"
  ]
  primary_network_gateway = "192.168.1.1"

  disk_default_size = "40G"
  disk_default_storage_pool = "local-lvm"

  tags = [
    "tag1",
    "tag2"
  ]

}
