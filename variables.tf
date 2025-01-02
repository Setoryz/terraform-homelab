variable "cloudinit_user" { type = string }
variable "cloudinit_password" {
  type      = string
  sensitive = true
}
variable "cloudinit_sshkey" {
  type      = string
  sensitive = true
}

variable "template" {
  type = string
}
variable "static_ip_prefix" { type = string }
variable "network_prefix" { type = string }
variable "network_gateway" { type = string }

variable "proxmox_nodes" {
  default = ["pve-main", "pve-node-1"]
}

variable "vm_resources" {
  description = "Configuration for CPU cores and memory for different node types"
  type = map(object({
    cores  = number
    memory = number
    disk   = number
  }))
  default = {
    control_plane = { cores = 2, memory = 2048, disk = 24 }
    worker_large  = { cores = 2, memory = 4096, disk = 48 }
    worker_small  = { cores = 1, memory = 2048, disk = 24 }
  }
}

variable "control_planes" {
  type = list(object({
    name = string
    node = string
  }))

  default = [
    { name = "k8s-ctrl-0", node = "pve-main" },
    { name = "k8s-ctrl-1", node = "pve-node-1" }
  ]
}

variable "worker_nodes" {
  type = list(object({
    name  = string
    node  = string
    type  = string
    index = number
  }))
  default = [
    { name = "k8s-node-lg-0", node = "pve-main", type = "large", index = 0 },
    { name = "k8s-node-lg-1", node = "pve-main", type = "large", index = 1 },
    { name = "k8s-node-lg-2", node = "pve-node-1", type = "large", index = 2 },

    { name = "k8s-node-sm-0", node = "pve-main", type = "small", index = 0 },
    { name = "k8s-node-sm-1", node = "pve-main", type = "small", index = 1 },
    { name = "k8s-node-sm-2", node = "pve-node-1", type = "small", index = 2 },
  ]
}
