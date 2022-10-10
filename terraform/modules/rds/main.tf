resource "aws_db_instance" "default" {
    allocated_storage    = 10
    engine               = "mariadb"
    engine_version       = "10.3"
    instance_class       = "db.t2.micro"
    username             = var.DB_USERNAME
    password             = var.DB_PASSWORD
    parameter_group_name = aws_db_parameter_group.mariadb.id
    skip_final_snapshot  = true
    vpc_security_group_ids = [aws_security_group.allow_db_traffic.id]
    storage_type = "gp2"
    db_subnet_group_name = aws_db_subnet_group.mariadb-subnet-group.id
}
