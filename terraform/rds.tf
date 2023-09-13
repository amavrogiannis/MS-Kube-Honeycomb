variable "db_password" {
  description = "RDS password for user"
  type        = string
  sensitive   = true
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "hcdemo"

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "14.9"
  family            = "postgres14"



  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.rds_sg.security_group_id]
  parameter_group_name   = module.vpc.database_subnet_group_name

  publicly_accessible = false
  skip_final_snapshot = true

  maintenance_window = "Mon:00:00-Mon:03:00"

  db_name  = "hctable"
  username = "hcuser"
  password = var.db_password
  port     = 5432

  multi_az = false

  tags = local.tags

  depends_on = [
    module.vpc
  ]

}