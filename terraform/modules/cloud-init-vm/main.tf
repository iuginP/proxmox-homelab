
/* Uses cloud-init options from Proxmox 5.2 onward */
resource "proxmox_vm_qemu" "cloudinit" {
  name    = "${local.vm_name}-${count.index + 1}"
  desc    = local.vm_description
  vmid    = local.vm_id+count.index
  os_type = "cloud-init"
  agent   = 1
  onboot  = local.vm_start_on_boot
  boot    = local.vm_boot_order

  count   = local.vm_count

  target_node = local.proxmox_node
  pool        = local.proxmox_resource_pool

  clone      = local.template_clone
  full_clone = local.template_full_clone

  cores   = local.cores
  sockets = local.sockets
  memory  = local.memory

  # Disks
  scsihw = "virtio-scsi-pci"  # <-- (Optional) Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  disks {  # <-- ! changed in 3.x.x
    ide {
      ide0 {
        cloudinit {
          storage = "${local.disk_default_storage_pool}"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "${local.disk_default_storage_pool}"
          size = "${local.disk_default_size}"  # <-- Change the desired disk size, ! since 3.x.x size change will trigger a disk resize
          # iothread = true  # <-- (Optional) Enable IOThread for better disk performance in virtio-scsi-single
          replicate = false  # <-- (Optional) Enable for disk replication
        }
      }
    }
  }

  # Primary Network
  network {
    id     = local.primary_network.id
    model  = local.primary_network.model
    bridge = local.primary_network.bridge
    tag    = local.primary_network.tag
  }

  # Additional Networks - Future

  # Cloud-Init Drive
  ciuser     = local.admin_username
  cipassword = local.admin_password
  sshkeys    = <<-EOF
  %{for key in local.admin_public_ssh_keys~}
  ${key}
  %{endfor~}
  EOF

  # ci_wait = null
  # cicustom = null

  nameserver   = null
  searchdomain = null
  ipconfig0    = join(",", compact([
    var.primary_network_cidr_address[count.index] != null ? "ip=${var.primary_network_cidr_address[count.index]}" : "ip=dhcp",
    var.primary_network_gateway != null ? "gw=${var.primary_network_gateway}" : ""
  ]))

  tags = join(",", local.tags)

}
