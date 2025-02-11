resource "proxmox_vm_qemu" "test_vms" {
  
  # -- General settings

  name = "vm-test-${count.index + 1}" # count.index starts at 0
  desc = "description"
  count = 3 # Establishes how many instances will be created 
  target_node = "${var.proxmox_node}"  # <-- Change to the name of your Proxmox node (if you have multiple nodes)
  agent = 1  # <-- (Optional) Enable QEMU Guest Agent
  tags = "test,ubuntu"

  # -- Template settings

  clone = "ubuntu-server-noble"  # <-- Change to the name of the template or VM you want to clone
  full_clone = true  # <-- (Optional) Set to "false" to create a linked clone

  # -- Boot Process

  onboot = true
  startup = ""  # <-- (Optional) Change startup and shutdown behavior
  automatic_reboot = false  # <-- Automatically reboot the VM after config change

  # -- Hardware Settings

  qemu_os = "other"
  bios = "ovmf"
  cores = 2
  sockets = 1
  cpu_type = "host"
  memory = 2048
  balloon = 2048  # <-- (Optional) Minimum memory of the balloon device, set to 0 to disable ballooning
  

  # -- Network Settings

  network {
    id     = 0  # <-- ! required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
    # tag = 0 # <-- (Optional) This tag can be left off if you are not taking advantage of VLANs
  }

  # -- Disk Settings
  
  scsihw = "virtio-scsi-single"  # <-- (Optional) Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  
  disks {  # <-- ! changed in 3.x.x
    ide {
      ide0 {
        cloudinit {
          storage = "${var.proxmox_storage_iso}"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = "${var.proxmox_storage_vm}"
          size = "20G"  # <-- Change the desired disk size, ! since 3.x.x size change will trigger a disk resize
          iothread = true  # <-- (Optional) Enable IOThread for better disk performance in virtio-scsi-single
          replicate = false  # <-- (Optional) Enable for disk replication
        }
      }
    }
  }

  # -- Cloud Init Settings

  ipconfig0 = "ip=192.168.15.${count.index + 70}/24,gw=192.168.15.1"  # <-- Change to your desired IP configuration
  nameserver = "192.168.15.1"  # <-- Change to your desired DNS server
  ciuser = "${var.account_username}"
  sshkeys = "${var.account_ssh_public}"  # <-- (Optional) Change to your public SSH key
}