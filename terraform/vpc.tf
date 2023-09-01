module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "alex-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["eu-west-2a", "eu-west-2b"]
  database_subnets = ["10.0.31.0/24", "10.0.32.0/24"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = local.tags

}