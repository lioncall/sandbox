variable "name" {}

variable "instance_count" {}

variable "common_tags" {
  default = {}
}

variable subnet_ids { 
}

variable "vpc_id" {
  description = "The ID of the VPC that the RDS cluster will be created in"
}