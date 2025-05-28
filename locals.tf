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
