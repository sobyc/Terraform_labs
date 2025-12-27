
variable "nsg_csv_path" {
  description = "Path to the CSV file describing Network Security Groups."
  type        = string

}

variable "default_resource_group_name" {
  description = "Fallback RG name when CSV row has empty resource_group."
  type        = string
  default     = null
}

variable "default_network_security_group_name" {
  description = "Fallback network security group name when CSV row has empty network_security_group_name."
  type        = string
  default     = "rt-01"
}

variable "default_location" {
  description = "Fallback location when CSV row has empty location."
  type        = string
  default     = null
}