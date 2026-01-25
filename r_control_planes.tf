module "control_planes" {
  source   = "./modules/proxmox-vm"
  for_each = { for idx, cp in var.control_planes : cp.name => merge(cp, { _idx = idx }) }

  name        = each.value.name
  target_node = each.value.node
  clone       = var.template

  cores  = var.vm_resources["control_plane"].cores
  memory = var.vm_resources["control_plane"].memory

  scsi0_size    = var.vm_resources["control_plane"].disk
  scsi0_storage = "local-lvm"

  tags          = var.tags["control_planes"]
  startup_order = 7

  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  sshkeys    = var.cloudinit_sshkey

  searchdomain = var.dns_domain
  nameserver   = var.dns_nameserver

  ipconfig0 = "ip=${var.static_ip_prefix}.${local.vmid_suffix_by_name[each.key]}/${var.network_prefix},gw=${var.network_gateway}"
  vmid      = "3${local.vmid_suffix_by_name[each.key]}"
}
