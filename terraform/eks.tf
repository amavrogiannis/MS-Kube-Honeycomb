module "eks" {
  source = "terraform-aws-modules/eks/aws"
  # insert the 9 required variables here

  cluster_name                    = "alex-hc-eks"
  cluster_version                 = "1.27"
  subnet_ids                      = module.vpc.public_subnets
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # enable_irsa_support = false
  # oidc_provider_enabled = false

  eks_managed_node_group_defaults = {
    disk_size      = 60 // Disk size is measured in GiB
    instance_types = ["t3.medium"]
    vpc_security_group_ids = 
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  #EKS allocates the vallue of having max instances "2", where "1" is desired. The instance running mode, is set to ON_DEMAND, there is also "SPOT" option too. 
  eks_managed_node_groups = {
    deployment = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      name            = "managed-nodes-alexm"
      use_name_prefix = true

      subnet_ids = module.vpc.private_subnets

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      node_role_arn = "arn:aws:iam::948754295911:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"

      use_custom_launch_template = false
      disk_size                  = 60

      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      create_iam_role          = true
      iam_role_name            = "alex-hc-eks-node-role"
      iam_role_use_name_prefix = true
      iam_role_description     = "EKS managed node group complete example role"
    }
  }

  tags = local.tags

  depends_on = [module.vpc] // Important to demand EKS service to wait, once the VPC is created. 

}