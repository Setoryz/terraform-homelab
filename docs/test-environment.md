# Test Environment Notes

The `environments/test/` root is a copy of `environments/homelab/` and shares the same module code.

Because both environments target the same Proxmox cluster, do not apply the test environment with the
same inputs as homelab. You must override values to avoid collisions.

Minimum safeguards for test:
- Use a separate backend/state (via `terraform init -backend-config=...`).
- Use unique VM names, VMIDs, and IPs.

This repo enforces basic isolation in `environments/test/`:
- VM names are prefixed with `test-`.
- VMID/IP suffixes use a separate range.
- Recommended IP range is `10.0.2.x`.

Suggested workflow:
1) Copy the sample var file: `cp terraform.test.tfvars.sample terraform.test.tfvars`
2) Update `terraform.test.tfvars` with test-specific values.
3) Run from `environments/test/`:

```bash
terraform init -backend-config=...
terraform validate
terraform plan -out=tfplan -var-file=../../terraform.test.tfvars
```
