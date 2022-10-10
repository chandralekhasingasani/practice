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
  key    = "deployer.pem"
  source = "deployer"
}

resource "aws_instance" "web" {
  depends_on    = [aws_key_pair.deployer]
  count         = 1
  ami           = "ami-0bb6af715826253bf"
  instance_type = "t3.micro"
  subnet_id     = element(var.PUBLIC_SUBNET_IDS,count.index)
  key_name      = aws_key_pair.deployer.key_name

  vpc_security_group_ids = [aws_security_group.allow_http_internal.id,aws_security_group.allow_ssh.id]
  tags = {
    Name = "web"
  }
  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file("deployer")}"
    host     = "${element(aws_instance.web.*.private_ip,count.index)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install epel-release -y",
      "sudo yum install mariadb git ansible -y",
      "ansible-pull  -U https://github.com/r-devops/tw-setup.git deploy.yml -e DBHOST=${var.DBHOST} -e DBPASS=${var.DBPASS} -e DBUSER=${var.DBUSER} -e IPADDRESS=$(curl -s ifconfig.me)"
    ]
  }
}