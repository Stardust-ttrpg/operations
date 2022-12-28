variable "common_tags" {
  default     = {}
  description = "Common resource tags"
  type        = map(string)
}

variable "resource_prefix" {
  type        = string
  description = "Standard prefix to add before resources"
}

variable "vpc_cidr_block" {
  type  = string
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable instance_type {
  type = string
}

variable volume_size {
  type = number
  default = 20
}

variable subnet_id {
  type = string
}

variable unique_id {
  type = string
}