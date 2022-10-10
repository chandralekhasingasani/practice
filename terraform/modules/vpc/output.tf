output "VPC_ID" {
  value = aws_vpc.main.id
}

output "PRIVATE_SUBNET_IDS" {
  value = aws_subnet.private-subnet.*.id
}

output "PUBLIC_SUBNET_IDS" {
  value = aws_subnet.public-subnet.*.id
}