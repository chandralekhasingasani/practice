output "number_of_az" {
  value = "${module.vpc.availability_count}"
}