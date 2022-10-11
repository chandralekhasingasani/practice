variable "CIDR_BLOCK" {}
variable "PROJECT_NAME" {}
variable "DB_PASSWORD" {
  sensitive = true
}
variable "DB_USERNAME" {
  sensitive = true
}