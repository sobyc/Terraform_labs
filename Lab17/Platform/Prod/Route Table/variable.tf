
variable "rt_csv_path" {
  description = "Path to the CSV file describing Route Tables."
  type        = string

}

variable "default_resource_group_name" {
  description = "Fallback RG name when CSV row has empty resource_group."
  type        = string
  default     = null
}

variable "default_route_table_name" {
  description = "Fallback route table name when CSV row has empty route_table_name."
  type        = string
  default     = "rt-01"
}

variable "default_location" {
  description = "Fallback location when CSV row has empty location."
  type        = string
  default     = null
}