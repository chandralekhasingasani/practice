# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/dev"
  CIDR_BLOCK = var.CIDR_BLOCK
  PROJECT_NAME = var.PROJECT_NAME
}