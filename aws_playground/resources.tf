provider "aws" {
  profile   = "default"
  region    = "us-east-1"
}

##################################################################################
# DATA
##################################################################################
data "aws_availability_zones" "available" {}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "public_cidrsubnet" {
  count = var.subnet_count[terraform.workspace]

  template = "$${cidrsubnet(vpc_cidr,8,current_count)}"

  vars = {
    vpc_cidr      = var.network_address_space[terraform.workspace]
    current_count = count.index
  }
}


##################################################################################
# RESOURCES
##################################################################################

#Random ID
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${local.env_name}-vpc"
  version = "2.15.0"
  enable_dns_hostnames = true
  cidr            = var.network_address_space[terraform.workspace]
  azs             = slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace])
  public_subnets  = data.template_file.public_cidrsubnet[*].rendered
  private_subnets = []

  tags = local.common_tags
}


# module "hamster_app" {
#    source      = ".\\Modules\\app"
#    name = "hamster"
#    environment_name = local.env_name
#    vpc_id = module.vpc.vpc_id 
#    subnet_ids = module.vpc.public_subnets
#    max_instance_count = var.max_instance_count[terraform.workspace]
#    instance_size = var.instance_size[terraform.workspace] 
#    cidr = var.network_address_space[terraform.workspace]
#    common_tags = local.common_tags 
#    access_logs_bucket_name = local.lb_access_logs_bucket_name
#    access_logs_bucket_prefix = local.app_lb_access_logs_bucket_prefix
# }


# module "races_table" {
#   name = "races"
#   hash_key = "id"
#   type = "N" 
#   source      = ".\\Modules\\dynamo"
#   common_tags = local.common_tags
# }


module "rds_database" {
  name = "users"
  instance_count = 2
  vpc_id = module.vpc.vpc_id 
  subnet_ids = module.vpc.public_subnets
  source      = ".\\Modules\\rds"
  common_tags = local.common_tags
}

