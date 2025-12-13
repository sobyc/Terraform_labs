This folder deploys the `prod` CI environment resources (resource groups, vnets, subnets).

Configuration pointers:
- `variable "environment"` controls the prefix in VNet names.
- VNet names are computed as `vnet-<env_abbr>-<region>-<role>`.
- `region`, `location`, and `env_abbr_map` are centralized in the root `Lab21/variables.tf` and can be overridden via `terraform.tfvars` in the root.
- Use `local.custom_subnet_names` to override the default subnet names for specific roles (e.g., `hub`).

To plan and apply from this folder:
```
terraform init
terraform plan
terraform apply
```
