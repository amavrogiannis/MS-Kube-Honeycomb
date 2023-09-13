module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "alexm-rds-sg"
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "EKS Remote"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Outbound Any"
      cidr        = "0.0.0.0"
    },
  ]
  tags = local.tags

}

module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "alexm-bastion-sg"
  description = "Security group for bastion"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Ingress any"
      cidr_blocks = "147.12.183.132/32"
    },
    # {
    #   from_port = 5432
    #   to_port = 5432
    #   protocol = "tcp"
    #   description = "Postgress inbound"
    #   security_group_id = module.rds_sg.security_group_id
    # },
    # {
    #   from_port   = 0
    #   to_port     = 0
    #   protocol    = -1
    #   description = "Ingress any"
    #   cidr_blocks = "0.0.0.0/0"
    # },
  ]
  #egress
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Outbound Any"
      cidr        = "0.0.0.0"
    },
  ]
  tags = local.tags

}

# module "eks_sg" {
#   source  = "terraform-aws-modules/security-group/aws"

#   name        = "alexm-eks-sg"
#   description = "Security group for EKS Nodes"
#   vpc_id      = module.vpc.vpc_id

#   ingress_with_cidr_blocks = [
#     {
#       rule = "postgresql-tcp"
#       cidr_blocks = module.vpc.vpc_cidr_block
#     },
#     {
#       from_port = 22
#       to_port = 22
#       protocol = "tcp"
#       description = ""
#     }
#   ]
  
# }