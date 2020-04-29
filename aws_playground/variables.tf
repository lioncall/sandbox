##################################################################################
# VARIABLES
##################################################################################
 
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "us-east-1"
}
variable network_address_space {
  type = map(string)
}
variable "instance_size" {
  type = map(string)
}
variable "subnet_count" {
  type = map(number)
}
variable "max_instance_count" {
  type = map(number)
}

variable "billing_code_tag" {}
variable "bucket_name_prefix" {}
 

##################################################################################
# LOCALS
##################################################################################

locals {
  env_name = lower(terraform.workspace)

  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = local.env_name
  }

  lb_access_logs_bucket_name = "${var.bucket_name_prefix}-${local.env_name}-lb-access-logs-${random_integer.rand.result}" 
  app_lb_access_logs_bucket_prefix = "app-lb"

}