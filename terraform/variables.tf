
# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_tls_insecure" {
    type = bool
    default = false
}

variable "proxmox_storage" {
  type =  string
  default = "local-lvm"
}

variable "proxmox_node" {
  type =  string
}

variable "account_username" {
  type =  string
}

variable "account_password" {
  type =  string
  sensitive = true
}

variable "account_ssh_public" {
  type =  string
  sensitive = true
}
