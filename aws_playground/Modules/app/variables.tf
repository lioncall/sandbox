variable "name" {}
variable "environment_name" {}
variable "vpc_id" {}

variable subnet_ids {}

variable max_instance_count {}

variable instance_size {}

variable "cidr" {}

variable "common_tags" {
  default = {}
}
 
variable "access_logs_bucket_name" {}

variable "access_logs_bucket_prefix" {}
