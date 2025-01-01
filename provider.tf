variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type      = string
  sensitive = true
}

variable "pm_api_token_secret" {
  type      = string
  sensitive = true
}

terraform {
  # required_version 
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }

  backend "pg" {
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  # pm_password = 
  # pm_user = 
  # pm_otp = 

  # api token id is in the form of <username>@pam!<tokenid>
  pm_api_token_id = var.pm_api_token_id

  # this is the full secret wrapped up in quotes
  pm_api_token_secret = var.pm_api_token_secret
}
