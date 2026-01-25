module "nfs_nodes" {
  source   = "./modules/proxmox-vm"
  for_each = { for idx, cp in var.nfs_nodes : cp.name => merge(cp, { _idx = idx }) }

  name        = each.value.name
  target_node = each.value.node
  clone       = var.template

  cores  = var.vm_resources["node_${each.value.type}"].cores
  memory = var.vm_resources["node_${each.value.type}"].memory

  scsi0_size    = var.vm_resources["node_${each.value.type}"].disk
  scsi0_storage = each.value.storage

  tags          = each.value.tags
  startup_order = 1

  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  sshkeys    = var.cloudinit_sshkey

  ipconfig0 = "ip=${var.static_ip_prefix}.${local.nfs_node_start_id_suffix + each.value._idx}/${var.network_prefix},gw=${var.network_gateway}"
  vmid      = "3${local.nfs_node_start_id_suffix + each.value._idx}"
}
