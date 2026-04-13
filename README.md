# Terraform Proxmox (Homelab)

This repository manages a single Proxmox cluster using Terraform with environment roots and shared modules.

## Repository Layout
- `modules/proxmox-vm/`: reusable VM module.
- `environments/homelab/`: active homelab root.
- `environments/test/`: test root scaffold (do not apply without isolation).
- `terraform.tfvars.sample`: base input template.

## Run Homelab
Run Terraform from `environments/homelab/`:

```bash
cd environments/homelab
terraform init
terraform validate
terraform plan -out=tfplan -var-file=../../terraform.tfvars
terraform apply tfplan
```

## Safety Rules
- VMIDs and IPs are locked; any drift is a hard stop.
- Never apply `environments/test/` against the same state, names, VMIDs, or IPs as homelab.
- Review the plan for any destroy/recreate before apply.
