Module: nsg

Creates Azure Network Security Groups (NSGs) and optional associations to subnet IDs.

Inputs
- `nsgs` (list): Each item: `{ name, nsg_rules = [], associate_subnet_ids = [] }`.
- `resource_group_name` (string)
- `location` (string)
- `tags` (map)

Outputs
- `nsg_ids`, `nsg_names`, `associations`

Notes
- NSG-to-subnet associations are created for every `associate_subnet_ids` entry.
