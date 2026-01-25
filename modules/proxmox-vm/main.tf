terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

resource "proxmox_vm_qemu" "this" {
  name        = var.name
  description = var.name
  target_node = var.target_node

  clone = var.clone
  agent = var.agent

  os_type = var.os_type

  cpu {
    cores   = var.cores
    vcores  = var.vcores
    sockets = var.sockets
    type    = var.cpu_type
  }

  memory             = var.memory
  balloon            = var.balloon
  scsihw             = var.scsihw
  bootdisk           = var.bootdisk
  start_at_node_boot = var.start_at_node_boot
  tags               = var.tags

  startup_shutdown {
    order         = var.startup_order
    startup_delay = var.startup_delay
  }

  lifecycle {
    ignore_changes = [bootdisk]
  }

  disks {
    ide {
      ide2 {
        cloudinit {
          storage = var.cloudinit_storage
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.scsi0_size
          cache   = var.scsi0_cache
          storage = var.scsi0_storage
        }
      }

      dynamic "scsi1" {
        for_each = var.scsi1_size != null && var.scsi1_storage != null ? [1] : []
        content {
          disk {
            size    = var.scsi1_size
            cache   = var.scsi0_cache
            storage = var.scsi1_storage
          }
        }
      }
    }
  }

  network {
    id     = 0
    model  = var.network_model
    bridge = var.network_bridge
  }

  boot = var.boot

  ciuser     = var.ciuser
  cipassword = var.cipassword
  ciupgrade  = var.ciupgrade
  sshkeys    = var.sshkeys

  searchdomain = var.searchdomain
  nameserver   = var.nameserver

  ipconfig0 = var.ipconfig0
  vmid      = var.vmid
}
