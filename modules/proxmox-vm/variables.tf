variable "name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "clone" {
  type    = string
  default = null
}

variable "agent" {
  type    = number
  default = 1
}

variable "os_type" {
  type    = string
  default = "cloud-init"
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "balloon" {
  type    = number
  default = null
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "sockets" {
  type    = number
  default = 1
}

variable "vcores" {
  type    = number
  default = 0
}

variable "scsihw" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "bootdisk" {
  type    = string
  default = "scsi0"
}

variable "start_at_node_boot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = string
  default = null
}

variable "startup_order" {
  type = number
}

variable "startup_delay" {
  type    = number
  default = 10
}

variable "cloudinit_storage" {
  type    = string
  default = "local-lvm"
}

variable "scsi0_size" {
  type = number
}

variable "scsi0_storage" {
  type = string
}

variable "scsi0_cache" {
  type    = string
  default = "none"
}

variable "scsi1_size" {
  type    = number
  default = null
}

variable "scsi1_storage" {
  type    = string
  default = null
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_model" {
  type    = string
  default = "virtio"
}

variable "boot" {
  type    = string
  default = "order=scsi0"
}

variable "ciuser" {
  type = string
}

variable "cipassword" {
  type      = string
  sensitive = true
}

variable "ciupgrade" {
  type    = bool
  default = false
}

variable "sshkeys" {
  type      = string
  sensitive = true
}

variable "searchdomain" {
  type    = string
  default = null
}

variable "nameserver" {
  type    = string
  default = null
}

variable "ipconfig0" {
  type = string
}

variable "vmid" {
  type = any
}
