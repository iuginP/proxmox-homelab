# https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2

module "dev_srv_rpx" {
  source = "./modules/cloud-init-vm"

  vm_name        = "dev-srv-rpx"
  vm_description = "Reverse Proxy Server on Ubuntu"
  vm_id          = 341
  vm_count       = 1
  cores          = 2
  sockets        = 1
  memory         = 4096

  proxmox_node = "${var.proxmox_node}"
  template_clone      = "ubuntu-server-24-04-cloud-init"
  template_full_clone = true

  admin_username = "${var.account_username}"
  admin_public_ssh_keys = ["${var.account_ssh_public}"]

  primary_network_cidr_address = [
    "172.16.100.41/24"
  ]
  primary_network_gateway = "172.16.100.1"
  primary_network_tag = 100

  disk_default_size = "40G"
  disk_default_storage_pool = "local-zfs"

  tags = [
    "ubuntu",
    "development",
    "rpx"
  ]
}
