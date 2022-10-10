resource "null_resource" "pem_creation" {
  provisioner "local-exec" {
    command = "yes y |ssh-keygen -q -t rsa -f deployer -N ''"
  }
}

module "pub_content"{
  source  = "matti/resource/shell"
  command = "cat deployer.pub"
}


module "pem_content"{
  source  = "matti/resource/shell"
  command = "cat deployer"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = module.pub_content.stdout
}

resource "aws_s3_bucket" "terraform-batch38" {
  bucket = "terraform-batch38"
  tags = {
    Name        = "terraform-batch38"
  }
}

# Upload an object
resource "aws_s3_bucket_object" "object" {
  depends_on = [aws_s3_bucket.terraform-batch38]
  bucket = "terraform-batch38"
  key    = "deployer"
  source = "deployer"
}