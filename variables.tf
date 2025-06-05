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

variable "dns_nameserver" { type = string }
variable "dns_domain" { type = string }

variable "proxmox_nodes" {
  default = ["pve-main", "pve-node-1"]
}

variable "vm_resources" {
  description = "Configuration for CPU cores and memory for different node types"
  type = map(object({
    cores         = number
    memory        = number
    disk          = number
    longhorn_disk = optional(number)
  }))
  default = {
    control_plane = { cores = 2, memory = 4096, disk = 24 }
    worker_large  = { cores = 2, memory = 4096, disk = 48, longhorn_disk = 256 }
    worker_small  = { cores = 1, memory = 4096, disk = 36, longhorn_disk = 256 }
    node_small    = { cores = 1, memory = 4096, disk = 1024 }
    vm_mini       = { cores = 1, memory = 1024, disk = 8 }
  }
}

variable "control_planes" {
  type = list(object({
    name = string
    node = string
  }))

  default = [
    { name = "k8s-ctrl-0", node = "pve-main" },
  ]
}

variable "worker_nodes" {
  type = list(object({
    name             = string
    node             = string
    type             = string
    index            = number
    longhorn_storage = string
  }))
  default = [
    { name = "k8s-worker-0", node = "pve-main", type = "large", index = 0, longhorn_storage = "thinpool-ssd" },
    { name = "k8s-worker-1", node = "pve-main", type = "large", index = 1, longhorn_storage = "thinpool-ssd" },
    { name = "k8s-worker-2", node = "pve-main", type = "large", index = 2, longhorn_storage = "thinpool-ssd" },

    { name = "k8s-worker-3", node = "pve-node-1", type = "large", index = 3, longhorn_storage = "local-lvm" },
    { name = "k8s-worker-sm-0", node = "pve-node-1", type = "small", index = 0, longhorn_storage = "local-lvm" },
  ]
}

variable "nfs_nodes" {
  type = list(object({
    name    = string
    node    = string
    type    = string
    storage = string
  }))

  default = [
    { name = "k8s-nfs-storage", node = "pve-node-1", type = "small", storage = "local-lvm" }
  ]
}

variable "hl_vm_nodes" {
  type = list(object({
    name    = string
    node    = string
    type    = string
    storage = string
  }))

  default = [
    { name = "tailscale", node = "pve-main", type = "mini", storage = "local-lvm" },
    { name = "cftunnel", node = "pve-main", type = "mini", storage = "local-lvm" }
  ]
}
