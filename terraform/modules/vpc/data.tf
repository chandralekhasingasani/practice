# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.
data "aws_availability_zones" "available" {
  state = "available"
}

output "availability_count" {
  value = length(data.aws_availability_zones.available.*.names)
}
