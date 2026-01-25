# Repository Guidelines

## Project Structure & Module Organization
This repository is a single Terraform configuration for Proxmox. The root directory holds all HCL sources:
- Core configuration: `main.tf`, `provider.tf`, `variables.tf`, `locals.tf`.
- Resource groups are split by role in `r_control_planes.tf`, `r_worker_nodes.tf`, `r_nfs_node.tf`, and `r_hl_vm_node.tf`.
- Inputs live in `terraform.tfvars` (local, uncommitted) with a template at `terraform.tfvars.sample`. The provider is pinned in `.terraform.lock.hcl`.

## Build, Test, and Development Commands
- `terraform init` initializes the working directory and configures the backend.
- `terraform fmt` formats all Terraform files to the standard style.
- `terraform validate` performs a static validation of the configuration.
- `terraform plan -out=tfplan` creates an execution plan and writes it to `tfplan`.
- `terraform apply tfplan` applies the previously generated plan.

## Coding Style & Naming Conventions
- Use `terraform fmt` before committing; indentation is handled automatically.
- Prefer snake_case for variable names (e.g., `cloudinit_sshkey`) and keep resource names consistent with existing patterns.
- Keep resource definitions grouped by role in the `r_*.tf` files to match the current layout.

## Testing Guidelines
There is no dedicated test framework in this repository. Use:
- `terraform validate` for configuration checks.
- `terraform plan` to review all changes before apply.

## Commit & Pull Request Guidelines
- Commit messages follow a Conventional Commits-style prefix, e.g., `chore: update resources`.
- Pull requests should include a clear description of changes and a `terraform plan` summary or output (redact secrets).

## Agent Workflow Requirements
- At the start of each new task, ask whether to create a new branch and suggest a Conventional Commits-style branch name (for example, `refactor/name-keyed-for-each`).
- Before proposing changes, confirm they are the safest senior-level approach given the repo constraints (especially no VM recreation and locked VMIDs/IPs).
- Review the actual file changes locally before asking the user to run any commands.
- After a task or phase is approved, make a commit using Conventional Commits style.
- When requested to open a pull request, use `gh pr create` and target the agreed base branch.

## Security & Configuration Tips
- Do not commit secrets. Keep credentials and tokens in `terraform.tfvars` or your local environment.
- Use `terraform.tfvars.sample` as the base for new environments.
