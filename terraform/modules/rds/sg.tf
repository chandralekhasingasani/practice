resource "aws_security_group" "allow_db_traffic" {
  name        = "allow_db_traffic"
  description = "Allow db inbound traffic"
  vpc_id      = var.VPC_ID

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = var.VPC_ID
  }

  tags = {
    Name = "allow_db_traffic"
  }
}