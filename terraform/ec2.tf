data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion-alex"

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  vpc_security_group_ids = [module.bastion_sg.security_group_id]

  key_name = "alex-m-temp"

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp2"
      volume_size = 16
    },
  ]

#   iam_role_name = aws_iam_role.role.name

  tags = local.tags

}

# resource "aws_iam_role" "role" {
#   name        = "alex-ec2-role-temp"
#   description = "this is a temp role for ec2 to connect"

#   assume_role_policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" : "ec2:DescribeInstances",
#           "Resource" : "*"
#       }]
#     }
#   )

# }

# data "aws_caller_identity" "current" {}

# resource "aws_iam_policy" "ec2_connect" {
#   name        = "alex-ec2-connect"
#   description = "this is a temp policy to connect to ec2 via aws connect"

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [{
#         "Effect" : "Allow",
#         "Action" : "ec2-instance-connect:SendSSHPublicKey",
#         "Resource" : "arn:aws:ec2:eu-west-2:948754295911:instance/*",
#         "Condition" : {
#           "StringEquals" : {
#             "aws:ResourceTag/Contact" : "alex.mavrogiannis"
#           }
#         }
#         }
#       ]
#     }
#   )
# }

# resource "aws_iam_role_policy_attachment" "role_policy_two" {
#   role       = aws_iam_role.role.name
#   policy_arn = aws_iam_policy.ec2_connect.arn

# }