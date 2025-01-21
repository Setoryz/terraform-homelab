resource "proxmox_vm_qemu" "control_planes" {
  for_each = { for idx, cp in var.control_planes : idx => cp }
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
  cores    = var.vm_resources["control_plane"].cores
  sockets  = 1
  vcpus    = 0
  cpu_type = "host"
  memory   = var.vm_resources["control_plane"].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"
  onboot   = true

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
          size    = var.vm_resources["control_plane"].disk
          cache   = "none"
          storage = "local-lvm"
          # discard    = true
          # backup     = true
          # asyncio    = "io_uring"
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

  # Setup ip address using cloud-init
  # Keep in mind to use CIDR notation for the ip
  ipconfig0 = "ip=${var.static_ip_prefix}.${local.control_plane_start_id_suffix + tonumber(each.key)}/${var.network_prefix},gw=${var.network_gateway}"
  vmid      = "3${local.control_plane_start_id_suffix + tonumber(each.key)}"
}
