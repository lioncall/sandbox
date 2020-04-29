 
resource "aws_db_subnet_group" "default" {
  name       = "aurora-subnet-group-${var.name}"
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { Name = "aurora-subnet-group-${var.name}" })
}
  
resource "aws_security_group" "rds_security_group" {
  name   = "${var.name}-rds-sg"
  vpc_id = var.vpc_id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = merge(var.common_tags, { Name = "${var.name}-rds-sg" })

}

# resource "aws_db_instance" "default" {
#   allocated_storage    = 20
#   skip_final_snapshot = true
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = var.name
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql5.7"
#   db_subnet_group_name = aws_db_subnet_group.default.name
#   vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  
#   tags = merge(var.common_tags, { Name = "${var.name}-rds-instance" })

# }


resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.instance_count
  identifier         = "aurora-cluster-${var.name}-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t2.small"
  publicly_accessible = true
  tags = merge(var.common_tags, { Name = "aurora-cluster-${var.name}-${count.index}" })
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "aurora-cluster-${var.name}"
  skip_final_snapshot     = true
  database_name           = var.name
  master_username         = "foo"
  master_password         = "bararbaz"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  db_subnet_group_name = aws_db_subnet_group.default.name
  tags = merge(var.common_tags, { Name = "aurora-cluster-${var.name}" })
}