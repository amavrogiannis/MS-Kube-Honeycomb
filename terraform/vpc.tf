module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "alex-vpc"
  cidr = "10.0.0.0/16"

  azs                  = ["eu-west-2a", "eu-west-2b"]
  database_subnets     = ["10.0.31.0/24", "10.0.32.0/24"]
  database_subnet_tags = local.tags
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_tags  = local.tags
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_tags   = local.tags

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_database_subnet_group = true

  enable_nat_gateway = true
  single_nat_gateway = false

  manage_default_network_acl = true
  default_network_acl_tags   = local.tags

  manage_default_route_table = true
  default_route_table_tags   = local.tags

  manage_default_security_group = true
  default_security_group_ingress = [{
    description = "public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }]
  default_security_group_egress = [{
    description      = "public outgoing"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
  }]
  default_security_group_tags = local.tags

  tags = local.tags

}