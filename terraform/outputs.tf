output "number_of_az" {
  value = "${module.vpc.availability_count}"
}

output "ami_id" {
  value = module.ec2.ami_id
}