moved {
  from = proxmox_vm_qemu.control_planes["0"]
  to   = proxmox_vm_qemu.control_planes["k8s-ctrl-0"]
}

moved {
  from = proxmox_vm_qemu.worker_nodes["0"]
  to   = proxmox_vm_qemu.worker_nodes["k8s-worker-0"]
}

moved {
  from = proxmox_vm_qemu.worker_nodes["1"]
  to   = proxmox_vm_qemu.worker_nodes["k8s-worker-1"]
}

moved {
  from = proxmox_vm_qemu.worker_nodes["2"]
  to   = proxmox_vm_qemu.worker_nodes["k8s-worker-2"]
}

moved {
  from = proxmox_vm_qemu.worker_nodes["3"]
  to   = proxmox_vm_qemu.worker_nodes["k8s-worker-3"]
}

moved {
  from = proxmox_vm_qemu.worker_nodes["4"]
  to   = proxmox_vm_qemu.worker_nodes["k8s-worker-sm-0"]
}

moved {
  from = proxmox_vm_qemu.nfs_nodes["0"]
  to   = proxmox_vm_qemu.nfs_nodes["k8s-nfs-storage"]
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["0"]
  to   = proxmox_vm_qemu.hl_vm_nodes["tailscale"]
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["1"]
  to   = proxmox_vm_qemu.hl_vm_nodes["docker-net"]
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["2"]
  to   = proxmox_vm_qemu.hl_vm_nodes["minio"]
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["3"]
  to   = proxmox_vm_qemu.hl_vm_nodes["docker-priv"]
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["4"]
  to   = proxmox_vm_qemu.hl_vm_nodes["harness-delegate-1"]
}

moved {
  from = proxmox_vm_qemu.control_planes["k8s-ctrl-0"]
  to   = module.control_planes["k8s-ctrl-0"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.worker_nodes["k8s-worker-0"]
  to   = module.worker_nodes["k8s-worker-0"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.worker_nodes["k8s-worker-1"]
  to   = module.worker_nodes["k8s-worker-1"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.worker_nodes["k8s-worker-2"]
  to   = module.worker_nodes["k8s-worker-2"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.worker_nodes["k8s-worker-3"]
  to   = module.worker_nodes["k8s-worker-3"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.worker_nodes["k8s-worker-sm-0"]
  to   = module.worker_nodes["k8s-worker-sm-0"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.nfs_nodes["k8s-nfs-storage"]
  to   = module.nfs_nodes["k8s-nfs-storage"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["tailscale"]
  to   = module.hl_vm_nodes["tailscale"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["docker-net"]
  to   = module.hl_vm_nodes["docker-net"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["minio"]
  to   = module.hl_vm_nodes["minio"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["docker-priv"]
  to   = module.hl_vm_nodes["docker-priv"].proxmox_vm_qemu.this
}

moved {
  from = proxmox_vm_qemu.hl_vm_nodes["harness-delegate-1"]
  to   = module.hl_vm_nodes["harness-delegate-1"].proxmox_vm_qemu.this
}
