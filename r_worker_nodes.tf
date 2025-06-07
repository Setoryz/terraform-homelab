
resource "proxmox_vm_qemu" "worker_nodes" {
  for_each = { for idx, cp in var.worker_nodes : idx => cp }
  name     = each.value.name
  desc     = each.value.name

  # Node name has to be the same name as within the cluster
  # this might not include the FQDN
  target_node = each.value.node

  # The destination resource pool for the new VM
  # pool = "pool0"

  # The template name to clone this vm from
  clone = var.template

  # Activate QEMU agent for this VM
  agent = 1

  os_type  = "cloud-init"
  memory   = var.vm_resources["worker_${each.value.type}"].memory
  cores    = var.vm_resources["worker_${each.value.type}"].cores
  sockets  = 1
  vcpus    = 0
  cpu_type = "host"
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  onboot   = true

  lifecycle {
    ignore_changes = [bootdisk]
  }

  # Setup the disk
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.vm_resources["worker_${each.value.type}"].disk
          cache   = "none"
          storage = "local-lvm"
        }
      }

      dynamic "scsi1" {
        for_each = var.vm_resources["worker_${each.value.type}"].longhorn_disk != null ? [1] : []
        content {
          disk {
            size    = var.vm_resources["worker_${each.value.type}"].longhorn_disk
            cache   = "none"
            storage = each.value.longhorn_storage
          }
        }
      }
    }
  }


  # Setup Network interface and assign vlan tag
  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot = "order=scsi0"

  # Cloud init Settings
  ciuser     = var.cloudinit_user
  cipassword = var.cloudinit_password
  ciupgrade  = false
  sshkeys    = var.cloudinit_sshkey

  # DNS Settings
  searchdomain = var.dns_domain
  nameserver   = var.dns_nameserver

  # Setup ip address using cloud-init
  # Keep in mind to use CIDR notation for the ip
  ipconfig0 = "ip=${var.static_ip_prefix}.${local.worker_suffixes[each.value.type] + tonumber(each.value.index)}/${var.network_prefix},gw=${var.network_gateway}"
  vmid      = "3${local.worker_suffixes[each.value.type] + tonumber(each.value.index)}"
}
