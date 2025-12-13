variable "region" {
  description = "Region abbreviation used in naming (e.g. ci for Central India)"
  type        = string
  default     = "ci"
}

variable "location" {
  description = "Azure location display name (e.g. Central India)"
  type        = string
  default     = "Central India"
}

variable "env_abbr_map" {
  description = "Map of environment names to abbreviations for naming (e.g. prod->pr)."
  type        = map(string)
  default = {
    prod    = "pr"
    dev     = "dev"
    staging = "stg"
    ci      = "ci"
  }
}
