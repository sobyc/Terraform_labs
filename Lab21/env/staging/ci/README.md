This folder deploys the `staging` CI environment resources and uses `variable.environment = "staging"`.

Naming and usage follow the same pattern as prod. `region`, `location`, and `env_abbr_map` are centralized at the Lab21 root `variables.tf`; to use them from this folder, either run from the Lab21 root or supply a `-var-file` when running terraform in this folder.
