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
  type = set(string)
  default = [
    "pve-main",
    "pve-n11",
    "pve-n12",
    "pve-n13",
    "pve-l21",
    "pve-node-1",
  ]
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
    control_plane = { cores = 2, memory = 8192, balloon = 6144, disk = 24 }
    worker_large  = { cores = 2, memory = 8192, balloon = 6144, disk = 48, longhorn_disk = 256 }
    worker_small  = { cores = 1, memory = 6144, balloon = 4096, disk = 36, longhorn_disk = 256 }
    node_small    = { cores = 1, memory = 4096, disk = 1024 }

    vm_micro           = { cores = 1, memory = 1024, balloon = 512, disk = 8 }
    vm_medium          = { cores = 2, memory = 2048, balloon = 1024, disk = 36 }
    vm_micro_docker    = { cores = 1, memory = 4096, balloon = 2048, disk = 16 }
    vm_medium_docker   = { cores = 2, memory = 6144, balloon = 4096, disk = 36 }
    vm_medium_delegate = { cores = 4, memory = 8192, balloon = 6144, disk = 36 }

    storage_hdd_large = { size = 1024, source = "storage-hdd" }
  }
}

variable "tags" {
  description = "Tags for VMs"
  type        = map(string)

  default = {
    control_planes = "admin;k8s;sensitive"
    k8s_worker     = "k8s;sensitive"

  }
}

variable "control_planes" {
  type = map(object({
    node = string
  }))

  default = {
    k8s-ctrl-0 = { node = "pve-main" }
  }

  validation {
    condition     = alltrue([for n in values(var.control_planes) : contains(var.proxmox_nodes, n.node)])
    error_message = "All control_planes.node values must be in var.proxmox_nodes."
  }
}

variable "worker_nodes" {
  type = map(object({
    node             = string
    type             = string
    index            = number
    longhorn_storage = string
  }))
  default = {
    k8s-worker-0    = { node = "pve-main", type = "large", index = 0, longhorn_storage = "thinpool-ssd" }
    k8s-worker-1    = { node = "pve-main", type = "large", index = 1, longhorn_storage = "thinpool-ssd" }
    k8s-worker-2    = { node = "pve-main", type = "large", index = 2, longhorn_storage = "thinpool-ssd" }
    k8s-worker-3    = { node = "pve-n11", type = "large", index = 3, longhorn_storage = "local-lvm" }
    k8s-worker-sm-0 = { node = "pve-n11", type = "small", index = 0, longhorn_storage = "local-lvm" }
  }

  validation {
    condition     = length(distinct([for n in values(var.worker_nodes) : "${n.type}:${n.index}"])) == length(var.worker_nodes)
    error_message = "worker_nodes must not reuse the same type+index (vmid/ip collision risk)."
  }

  validation {
    condition     = alltrue([for n in values(var.worker_nodes) : contains(var.proxmox_nodes, n.node)])
    error_message = "All worker_nodes.node values must be in var.proxmox_nodes."
  }
}

variable "nfs_nodes" {
  type = map(object({
    node    = string
    type    = string
    storage = string
    tags    = optional(string)
  }))

  default = {
    k8s-nfs-storage = {
      node    = "pve-n11"
      type    = "small"
      storage = "local-lvm"
      tags    = "k8s;network;storage;sensitive"
    }
  }

  validation {
    condition     = alltrue([for n in values(var.nfs_nodes) : contains(var.proxmox_nodes, n.node)])
    error_message = "All nfs_nodes.node values must be in var.proxmox_nodes."
  }
}

variable "hl_vm_nodes" {
  type = map(object({
    node    = string
    type    = string
    storage = string

    clone        = optional(bool)
    vm_id_suffix = optional(number)
    extra_disk   = optional(string)
    extra_disks  = optional(list(string))
    tags         = optional(string)
  }))

  default = {
    tailscale          = { node = "pve-l21", type = "micro", storage = "local-lvm", clone = true, tags = "network;sensitive;tailscale" }
    docker-net         = { node = "pve-l21", type = "micro_docker", storage = "local-lvm", clone = true, tags = "docker;network;sensitive" }
    minio              = { node = "pve-main", type = "medium", storage = "local-lvm", extra_disk = "hdd_large", clone = true, tags = "storage;sensitive" }
    docker-priv        = { node = "pve-n12", type = "medium_docker", storage = "local-lvm", vm_id_suffix = 5, clone = true, tags = "admin;docker;sensitive" }
    harness-delegate-1 = { node = "pve-n13", type = "medium_delegate", storage = "local-lvm", vm_id_suffix = 124, clone = true, tags = "automation;delegate;docker;harness;sensitive" }
    harness-delegate-2 = { node = "pve-n13", type = "medium_delegate", storage = "local-lvm", vm_id_suffix = 125, clone = true, tags = "automation;delegate;docker;harness;sensitive" }
  }

  validation {
    condition = length(distinct([
      for n in values(var.hl_vm_nodes) : n.vm_id_suffix if n.vm_id_suffix != null
      ])) == length([
      for n in values(var.hl_vm_nodes) : n.vm_id_suffix if n.vm_id_suffix != null
    ])
    error_message = "hl_vm_nodes vm_id_suffix values must be unique when set."
  }

  validation {
    condition     = alltrue([for n in values(var.hl_vm_nodes) : contains(var.proxmox_nodes, n.node)])
    error_message = "All hl_vm_nodes.node values must be in var.proxmox_nodes."
  }
}
