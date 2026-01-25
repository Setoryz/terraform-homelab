module "hl_vm_nodes" {
  source   = "./modules/proxmox-vm"
  for_each = { for idx, cp in var.hl_vm_nodes : cp.name => merge(cp, { _idx = idx }) }

  name        = each.value.name
  target_node = each.value.node
  clone       = try(each.value.clone, false) ? var.template : null

  cores   = var.vm_resources["vm_${each.value.type}"].cores
  memory  = var.vm_resources["vm_${each.value.type}"].memory
  balloon = var.vm_resources["vm_${each.value.type}"].balloon

  scsi0_size    = var.vm_resources["vm_${each.value.type}"].disk
  scsi0_storage = each.value.storage

  scsi1_size    = each.value.extra_disk != null ? var.vm_resources["storage_${each.value.extra_disk}"].size : null
  scsi1_storage = each.value.extra_disk != null ? var.vm_resources["storage_${each.value.extra_disk}"].source : null

  tags          = each.value.tags
  startup_order = 6

  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  sshkeys    = var.cloudinit_sshkey

  vmid = (each.value.vm_id_suffix != null ?
    3000 + each.value.vm_id_suffix :
    3000 + local.hl_vm_node_start_id_suffix + each.value._idx
  )
  ipconfig0 = "ip=${var.static_ip_prefix}.${
    each.value.vm_id_suffix != null ? each.value.vm_id_suffix :
    local.hl_vm_node_start_id_suffix + each.value._idx
  }/${var.network_prefix},gw=${var.network_gateway}"
}
