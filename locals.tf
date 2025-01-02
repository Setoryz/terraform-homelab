locals {
  control_plane_start_id_suffix = 150

  worker_small_start_id_suffix = 160
  worker_large_start_id_suffix = 170
}

locals {
  worker_suffixes = {
    small = local.worker_small_start_id_suffix
    large = local.worker_large_start_id_suffix
  }
}
