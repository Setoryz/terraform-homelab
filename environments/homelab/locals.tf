locals {
  nfs_node_start_id_suffix   = 110
  hl_vm_node_start_id_suffix = 120

  control_plane_start_id_suffix = 150
  worker_small_start_id_suffix  = 180
  worker_large_start_id_suffix  = 170
}

locals {
  worker_suffixes = {
    small = local.worker_small_start_id_suffix
    large = local.worker_large_start_id_suffix
  }
}

locals {
  # Explicit VMID/IP suffix registry to break dependence on list ordering.
  vmid_suffix_by_name = {
    k8s-ctrl-0         = 150
    k8s-worker-0       = 170
    k8s-worker-1       = 171
    k8s-worker-2       = 172
    k8s-worker-3       = 173
    k8s-worker-sm-0    = 180
    k8s-nfs-storage    = 110
    tailscale          = 120
    docker-net         = 121
    minio              = 122
    docker-priv        = 5
    harness-delegate-1 = 124
    harness-delegate-2 = 125
  }
}
