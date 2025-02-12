locals {
  version = "25.1"
  iso = "OPNsense-${local.version}-dvd-amd64.iso"
  url = "https://mirror.fra10.de.leaseweb.net/opnsense/releases/${local.version}/${local.iso}.bz2"
}

resource "proxmox_virtual_environment_download_file" "opnsense_download_img" {
  provider = bgpproxmox

  content_type            = "iso"
  datastore_id            = "${var.proxmox_storage_iso}"
  file_name               = "${local.iso}"
  node_name               = "${var.proxmox_node}"
  url                     = "${local.url}"
  decompression_algorithm = "bz2"
  checksum                = "68efe0e5c20bd5fbe42918f000685ec10a1756126e37ca28f187b2ad7e5889ca"
  checksum_algorithm      = "sha256"
  overwrite               = false
}

resource "proxmox_vm_qemu" "firewall" {
  depends_on = [
    proxmox_virtual_environment_download_file.opnsense_download_img
  ]

  name        = "OPNsenseFW"
  desc        = "OPNsense Firewall"
  target_node = "${var.proxmox_node}"
  os_type     = "Linux"
  cores       = 2
  sockets     = 1
  memory      = 2048

  # Storage
  scsihw      = "virtio-scsi-single"
  bootdisk    = "scsi0"
  disks {
    ide {
      ide2 {
        cdrom {
          iso = "${var.proxmox_storage_iso}:iso/${local.iso}"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size     = "10G"
          storage = "${var.proxmox_storage}"
          iothread = true
        }
      }
    }
  }

  network {
    id     = 0  # <-- ! required since 3.x.x
    model  = "virtio"
    bridge = "vmbr0"
  }

}