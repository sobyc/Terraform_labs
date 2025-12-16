variable "environment" {
  description = "Environment name used for resource name prefixes (e.g. prod, staging, dev)"
  type        = string
  default     = "staging"
}

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

/* region and location are centralized in Lab21/variables.tf.
   Keep an empty `env_abbr_map` variable so this folder can still be validated/run stand-alone.
*/

variable "env_abbr_map" {
  description = "Optional map to override environment abbreviations. Empty by default to use centralized map or internal fallback."
  type        = map(string)
  default     = {}
}

variable "vnets_with_name" {
  description = "Optional list of vnets (from CSV) to use instead of in-module defaults"
  type        = list(any)
  default     = []
}

variable "subnets_per_vnet" {
  description = "Optional list of subnet lists (from CSV) matching order of `vnets_with_name`"
  type        = list(any)
  default     = []
}
