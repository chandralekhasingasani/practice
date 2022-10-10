data "aws_ami" "ami" {
  name_regex = "Centos-7-DevOps-Practice"
}

output "ami_id" {
  value = data.aws_ami.ami.id
}