# Configure the AWS Provider
/*provider "aws" {
  region = "us-east-1"
}*/

module "vpc" {
  source = "./modules/vpc"
  CIDR_BLOCK = var.CIDR_BLOCK
  PROJECT_NAME = var.PROJECT_NAME
}

module "rds" {
  source = "./modules/rds"
  DB_PASSWORD = var.DB_PASSWORD
  DB_USERNAME = var.DB_USERNAME
  PRIVATE_SUBNET_IDS = module.vpc.PRIVATE_SUBNET_IDS
  VPC_ID = module.vpc.VPC_ID
  CIDR_BLOCK = var.CIDR_BLOCK
}

module "ec2" {
  source = "./modules/ec2"
  PUBLIC_SUBNET_IDS = module.vpc.PUBLIC_SUBNET_IDS
  VPC_ID = module.vpc.VPC_ID
  CIDR_BLOCK = var.CIDR_BLOCK
}

