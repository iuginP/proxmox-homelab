#### Required Parameters #####

variable "vm_name" {
  type        = string
  description = "The virtual machine name."
}

variable "template_clone" {
  type        = string
  description = "Name of the Proxmox template to clone from."
}

variable "admin_username" {
  type        = string
  description = "The username of the local administrator. This is set during the cloud-init process."
}

#### Optional Parameters #####

variable "vm_count" {
  type        = number
  description = "The number of VM to create with the configuration provided."
  default     = 1
}

variable "vm_id" {
  type        = number
  description = "The ID of the virtual machine. If not set, the next available ID will be used."
  default     = null
}

variable "vm_description" {
  type        = string
  description = "The virtual machine description."
  default     = null
}

variable "vm_start_on_boot" {
  type        = bool
  description = "Specifies whether a VM will be started during system bootup."
  default     = false
}

variable "vm_boot_order" {
  type        = string
  description = "The boot order for the VM. Proxmox 6.2 changed boot order text from 'cdn'."
  default     = ""
}

variable "template_full_clone" {
  type        = bool
  description = "Performs a full clone of the template when enabled."
  default     = true
}

variable "admin_password" {
  type        = string
  description = "The password of the local administrator. This is set during the cloud-init process. If this is null, admin_ssh_public_keys must be set."
  default     = null
}

variable "admin_public_ssh_keys" {
  type        = list(string)
  description = "The public keys of the local administrator. This is set during the cloud-init process. If this is null, admin_password must be set."
  default     = []
}

variable "sockets" {
  type        = number
  description = "How many CPU sockets to give the virtual machine."
  default     = 1
}

variable "cores" {
  type        = number
  description = "How many CPU cores to give the virtual machine."
  default     = 1
}

variable "memory" {
  type        = number
  description = "How much memory, in megabytes, to give the virtual machine."
  default     = 1024
}

variable "primary_network_id" {
  type        = number
  description = "ID of the virtual network adapter."
  default     = 0
}

variable "primary_network_model" {
  type        = string
  description = "Model of the virtual network adapter."
  default     = "virtio"

  validation {
    condition     = contains(["rtl8139", "ne2k_pci", "e1000", "pcnet", "virtio", "ne2k_isa", "i82551", "i82557b", "i82559er", "vmxnet3", "e1000-82540em", "e1000-82544gc", "e1000-82545em"], var.primary_network_model)
    error_message = "The Proxmox network model is invalid."
  }
}

variable "primary_network_bridge" {
  type        = string
  description = "Which Proxmox bridge to attach the adapter to."
  default     = "vmbr0"
}

variable "primary_network_tag" {
  type        = number
  description = "Which VLAN tag to specify."
  default     = "-1"
}

variable "primary_network_cidr_address" {
  type        = list(string)
  description = "The IP address with CIDR block for the primary network interface. DHCP will be used if not set."
  default     = []
}

variable "primary_network_gateway" {
  type        = string
  description = "The network gateway to use for the primary network interface."
  default     = null
}

variable "disk_default_storage_pool" {
  type        = string
  description = "Name of the Proxmox storage pool to store the virtual machine disk on."
  default     = "local-lvm"
}

variable "disk_default_size" {
  type        = string
  description = "The size of the disk, including a unit suffix, such as 10G to indicate 10 gigabytes."
  default     = null
}

variable "proxmox_node" {
  type        = string
  description = "Which node in the Proxmox cluster to start the virtual machine on during creation."
  default     = "proxmox"
}

variable "proxmox_resource_pool" {
  type        = string
  description = "Name of resource pool to create virtual machine in."
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "List of virtual machine tags."
  default     = []
}
