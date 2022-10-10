resource "aws_db_parameter_group" "mariadb" {
  name   = "mariadb"
  family = "mariadb10.3"
}