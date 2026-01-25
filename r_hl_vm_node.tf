module "hl_vm_nodes" {
  source   = "./modules/proxmox-vm"
  for_each = var.hl_vm_nodes

  name        = each.key
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

  vmid = 3000 + (
    each.value.vm_id_suffix != null ? each.value.vm_id_suffix : local.vmid_suffix_by_name[each.key]
  )
  ipconfig0 = "ip=${var.static_ip_prefix}.${
    each.value.vm_id_suffix != null ? each.value.vm_id_suffix : local.vmid_suffix_by_name[each.key]
  }/${var.network_prefix},gw=${var.network_gateway}"
}
