
module "worker_nodes" {
  source   = "./modules/proxmox-vm"
  for_each = { for idx, cp in var.worker_nodes : cp.name => cp }

  name        = each.value.name
  target_node = each.value.node
  clone       = var.template

  cores   = var.vm_resources["worker_${each.value.type}"].cores
  memory  = var.vm_resources["worker_${each.value.type}"].memory
  balloon = var.vm_resources["worker_${each.value.type}"].balloon

  scsi0_size    = var.vm_resources["worker_${each.value.type}"].disk
  scsi0_storage = "local-lvm"

  scsi1_size    = var.vm_resources["worker_${each.value.type}"].longhorn_disk
  scsi1_storage = each.value.longhorn_storage

  tags          = var.tags["k8s_worker"]
  startup_order = 8

  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  sshkeys    = var.cloudinit_sshkey

  searchdomain = var.dns_domain
  nameserver   = var.dns_nameserver

  ipconfig0 = "ip=${var.static_ip_prefix}.${local.worker_suffixes[each.value.type] + tonumber(each.value.index)}/${var.network_prefix},gw=${var.network_gateway}"
  vmid      = "3${local.worker_suffixes[each.value.type] + tonumber(each.value.index)}"
}
