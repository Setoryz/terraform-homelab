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
