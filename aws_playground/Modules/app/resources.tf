
# SECURITY GROUPS #
resource "aws_security_group" "lb-sg" {
  name   = "${var.name}_lb_sg"
  vpc_id = var.vpc_id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.environment_name}-${var.name}-lb-sg" })

}


resource "aws_security_group" "app-sg" {
  name   = "${var.name}_app_sg"
  vpc_id = var.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.environment_name}--${var.name}-app-sg" })

}

module "s3_lb_logs" {
  name = var.access_logs_bucket_name 
  prefix = var.access_logs_bucket_prefix
  source      = "..\\s3_lb_logs"
  common_tags = var.common_tags
}



resource "aws_lb_target_group" "app-tg" {
  name     = "${var.name}-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = merge(var.common_tags, { Name = "${var.environment_name}-${var.name}-app-tg" })
}

resource "aws_lb" "app-lb" {
  name = "${var.environment_name}-${var.name}-app-elb"
  load_balancer_type = "application"
  internal           = false
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.lb-sg.id]
  
  access_logs {
    bucket  = module.s3_lb_logs.bucket.bucket 
    prefix  = var.access_logs_bucket_prefix
    enabled = true
  }

  tags = merge(var.common_tags, { Name = "${var.environment_name}-${var.name}-app-lb" })

}

resource "aws_lb_listener" "app-lb-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  } 
}
 
resource "aws_launch_configuration" "app-lc" {
  name          = "${var.name}-app-lc"
  image_id      = "ami-0276f766e27009672" #data.aws_ami.aws-linux.id
  associate_public_ip_address = true
  key_name      = "dev-virginia"   
  instance_type = var.instance_size 
  security_groups = [aws_security_group.app-sg.id]
  user_data      = "IyEvYmluL2Jhc2gNCnN1ZG8gYXB0LWdldCB1cGRhdGUNCnN1ZG8gYXB0LWdldCAteSBpbnN0YWxsIGdpdA0KZ2l0IGNsb25lIGh0dHBzOi8vZ2l0aHViLmNvbS9yeWFubXVyYWthbWkvaGJmbC5naXQgL2hvbWUvYml0bmFtaS9oYmZsDQpjaG93biAtUiBiaXRuYW1pOiAvaG9tZS9iaXRuYW1pL2hiZmwNCmNkIC9ob21lL2JpdG5hbWkvaGJmbA0Kc3VkbyBucG0gaQ0Kc3VkbyBucG0gcnVuIHN0YXJ0"
} 


resource "aws_autoscaling_group" "app-as" {
  name                 = "${var.name}-app-as"
  launch_configuration = aws_launch_configuration.app-lc.name
  min_size             = 1
  max_size             = var.max_instance_count
  target_group_arns    = [aws_lb_target_group.app-tg.arn]
  vpc_zone_identifier  = var.subnet_ids

  lifecycle {
    create_before_destroy = true
  }
}