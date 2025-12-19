variable "rg_csv_path" {
  description = "Path to the CSV file describing Subnets."
  type        = string

}

variable "default_resource_group_name" {
  description = "Fallback RG name when CSV row has empty resource_group."
  type        = string
  default     = null
}

variable "default_location" {
  description = "Fallback location when CSV row has empty location."
  type        = string
  default     = null
  
}