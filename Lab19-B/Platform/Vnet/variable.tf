
variable "vnet_csv_path" {
  description = "Path to the CSV file describing VNets."
  type        = string
}

variable "default_resource_group_name" {
  description = "Fallback RG name when CSV row has empty resource_group."
  type        = string
  default     = null
}

variable "default_location" {
  description = "Fallback Azure location when CSV row has empty location."
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Tags applied to all VNets (merged with CSV tags; row wins on conflicts)."
  type        = map(string)
  default     = {}
}
