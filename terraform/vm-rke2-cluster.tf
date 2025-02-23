# https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2

module "dev_rke2_masters" {
  source = "./modules/cloud-init-vm"

  vm_name        = "dev-rke2-master"
  vm_description = "Ubuntu Server for RKE2 node"
  vm_id          = 330
  vm_count       = 3
  cores          = 2
  sockets        = 1
  memory         = 4096

  proxmox_node = "${var.proxmox_node}"
  template_clone      = "ubuntu-server-24-04-cloud-init"
  template_full_clone = true

  admin_username = "${var.account_username}"
  admin_public_ssh_keys = ["${var.account_ssh_public}"]

  primary_network_cidr_address = [
    "172.16.100.31/24",
    "172.16.100.32/24",
    "172.16.100.33/24"
  ]
  primary_network_gateway = "172.16.100.1"
  primary_network_tag = 100

  disk_default_size = "40G"
  disk_default_storage_pool = "local-zfs"

  tags = [
    "ubuntu",
    "development",
    "rke2",
    "rke2-master"
  ]
}

module "dev_rke2_workers" {
  source = "./modules/cloud-init-vm"

  vm_name        = "dev-rke2-worker"
  vm_description = "Ubuntu Server for RKE2 node"
  vm_id          = 335
  vm_count       = 3
  cores          = 4
  sockets        = 1
  memory         = 32768

  proxmox_node = "${var.proxmox_node}"
  template_clone      = "ubuntu-server-24-04-cloud-init"
  template_full_clone = true

  admin_username = "${var.account_username}"
  admin_public_ssh_keys = ["${var.account_ssh_public}"]

  primary_network_cidr_address = [
    "172.16.100.34/24",
    "172.16.100.35/24",
    "172.16.100.36/24"
  ]
  primary_network_gateway = "172.16.100.1"
  primary_network_tag = 100

  disk_default_size = "40G"
  disk_default_storage_pool = "local-zfs"

  tags = [
    "ubuntu",
    "development",
    "rke2",
    "rke2-worker"
  ]
}