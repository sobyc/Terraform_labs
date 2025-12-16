# Lab21 CSV templates and validation

This folder supports CSV-driven creation of VNets and Subnets using `vnets.csv` and `subnets.csv`.

Validation rules (applied during `terraform validate/plan`):
- Required columns:
- `vnets.csv` (global): `role`, `address_space` (optional: `name`, `location`, `env`) 
- `subnets.csv` (global): `role`, `subnet_name` (optional: `env`)

Per-environment CSVs (optional, take precedence when present):
- `vnets.prod.csv`, `vnets.dev.csv` — if present these rows are used first for the respective environment
- `subnets.prod.csv`, `subnets.dev.csv` — same precedence logic for subnets

Precedence behavior: per-env CSV file rows are loaded first and then global CSV rows that are either empty `env` or target the current environment are appended. This allows per-env overrides and global defaults.
- `address_space` values are validated as CIDRs (must be a valid IPv4 CIDR like `10.0.0.0/16`).
- Duplicate CIDRs or same network address with different prefixes are treated as overlaps and will cause a plan-time error.

Behavior:
- If a CSV row is missing required fields or contains invalid CIDRs, `terraform plan` will fail with a descriptive error.
- The VNet `resource_group_name` will default to `rg-<region>-<env_abbr>-<role>-01` if not provided.

If you'd like stricter overlap detection or additional checks (e.g., CIDR containment across arbitrary prefixes), I can add those as a follow-up enhancement.
