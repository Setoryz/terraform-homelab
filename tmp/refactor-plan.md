# Terraform Proxmox Refactor Plan (Single Environment)

## Goals and Guardrails
- Keep the current workflow: run `terraform plan` / `terraform apply` from repo root.
- Reduce duplication across `r_*.tf` files.
- Make later multi-environment support a directory move, not a rewrite.
- Non-negotiable: no existing VM may be destroyed or recreated.
- VMIDs and IPs are locked and must not change (Ansible depends on them).

## Phase 0: Safety and Hygiene (no behavior changes)
1) Expand `.gitignore` to avoid leaking state and plans:
   - Add: `*.tfstate*`, `tfplan`, `crash.log`, `.env.*`
2) Baseline checks:
   - `terraform fmt`
   - `terraform validate`
   - `terraform plan -out=tfplan`
3) Capture a “known good” plan summary before refactoring.
4) Hard stop rule for all phases:
   - If `terraform plan` shows any destroy/recreate for existing VMs, stop and fix before proceeding.

## Phase 1: Normalize Inputs (prepare for modules)
1) Introduce a unified `vm_profiles` map in `variables.tf`:
   - Keys like `control_plane`, `worker.large`, `vm.micro`
2) Stabilize resource addressing before modules:
   - Convert `for_each = { for idx, n in var.* : idx => n }`
   - To `for_each = { for n in var.* : n.name => n }`
   - Use `moved` blocks so Terraform does not recreate VMs
   - Pre-check: ensure all names are unique within each role list
3) Add validation:
   - `node` must be in `var.proxmox_nodes`
   - profile keys referenced by nodes must exist
4) Create locals that standardize naming and tags:
   - e.g., `local.common_tags`, `local.name_prefix`

## Phase 2: Create a Reusable VM Module
Create `modules/proxmox-vm/` that wraps `proxmox_vm_qemu`.

Suggested interface:
- Inputs: `name`, `target_node`, `profile`, `storage`, `ip_config`, `tags`, `disks`, `clone`
- Outputs: `vm_id`, `name`, `ipv4`

Keep this module focused on VM creation only (no role logic).

## Phase 3: Migrate One Role at a Time
1) Migrate `control_planes` first:
   - Replace the resource in `r_control_planes.tf` with a module call.
   - Ensure VM IDs, names, and tags stay identical.
2) Validate:
   - `terraform fmt && terraform validate`
   - `terraform plan -out=tfplan` (expect no or minimal drift)
3) Repeat for `worker_nodes`, then `nfs_nodes`, then `hl_vm_nodes`.

## Phase 4: Consolidate and Simplify
- Remove duplicate per-role logic that is now inside the module.
- Keep role-specific files, but have them only define data + module calls.

## Gaps and Mitigations (found during plan review)
1) **State/plan files are currently unignored**
   - Gap: `.gitignore` only includes `.terraform/`, `terraform.tfvars`, `.env`
   - Fix: add `*.tfstate*` and `tfplan` in Phase 0
2) **Node validation would fail with current defaults**
   - Gap: `var.proxmox_nodes` does not include nodes like `pve-n11`, `pve-n12`, `pve-l21`
   - Fix: either expand `var.proxmox_nodes` or defer strict validation until it matches reality
3) **Index-based `for_each` is fragile today**
   - Gap: current resources key by index, so reordering lists can force recreation
   - Fix: switch to name-keyed `for_each` early, with `moved` blocks
4) **Resource migration can trigger unexpected recreation**
   - Gap: moving from `resource` to `module` changes addresses again
   - Fix: use `moved` blocks to map old addresses to new ones (second wave)
5) **Provider quirks around disks/cloud-init**
   - Gap: Telmate provider fields can be sensitive to block structure changes
   - Fix: keep module blocks as close as possible to current resource arguments; migrate one role and plan carefully before proceeding

## Validation Checklist per Step
- `terraform fmt`
- `terraform validate`
- `terraform plan -out=tfplan`
- Review for: any destroy/recreate (must be zero), disk changes, network changes, VM ID changes, IP changes
