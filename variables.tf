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
    cores   = optional(number)
    memory  = optional(number)
    disk    = optional(number)
    balloon = optional(number)

    longhorn_disk = optional(number)
    size          = optional(number)
    source        = optional(string)
  }))
  default = {
    control_plane = { cores = 2, memory = 4096, disk = 24 }
    worker_large  = { cores = 2, memory = 6144, balloon = 4096, disk = 48, longhorn_disk = 256 }
    worker_small  = { cores = 1, memory = 6144, balloon = 4096, disk = 36, longhorn_disk = 256 }
    node_small    = { cores = 1, memory = 4096, disk = 1024 }

    vm_micro  = { cores = 1, memory = 1024, balloon = 512, disk = 8 }
    vm_medium = { cores = 2, memory = 4096, balloon = 1024, disk = 36 }

    storage_hdd_large = { size = 1024, source = "storage-hdd" }
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

    clone        = optional(bool)
    vm_id_suffix = optional(number)
    extra_disk   = optional(string)
    extra_disks  = optional(list(string))
  }))

  default = [
    { name = "tailscale", node = "pve-node-2", type = "micro", storage = "local-lvm", clone = true },
    { name = "cftunnel", node = "pve-node-2", type = "micro", storage = "local-lvm", clone = true },
    { name = "minio", node = "pve-main", type = "medium", storage = "local-lvm", extra_disk = "hdd_large", clone = true },
    { name = "docker-priv", node = "pve-node-2", type = "medium", storage = "local-lvm", vm_id_suffix = 5, clone = true }
  ]
}
