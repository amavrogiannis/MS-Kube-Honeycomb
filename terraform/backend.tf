provider "aws" {
  region  = "eu-west-2" #Select the region that you want to deploy the resources. 
  profile = "and"
}

terraform {
  backend "s3" {
    bucket         = "tf-hc-backend"
    encrypt        = true
    key            = "infra/terraform.tfstate"
    dynamodb_table = "alexm-backend"
    region         = "eu-west-2"
    profile        = "and"
  }
}
