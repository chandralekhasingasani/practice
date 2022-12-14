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
resource "aws_s3_object" "object" {
  depends_on = [aws_s3_bucket.terraform-batch38]
  bucket = "terraform-batch38"
  key    = "deployer.pem"
  source = "deployer"
}

resource "aws_instance" "web" {
  depends_on = [
    aws_key_pair.deployer]
  count = 1
  ami = "ami-026b57f3c383c2eec"
  instance_type = "t3.micro"
  subnet_id = element(var.PUBLIC_SUBNET_IDS, count.index)
  key_name = "deployer-key"

  vpc_security_group_ids = [
    aws_security_group.allow_http_internal.id,
    aws_security_group.allow_ssh.id]
  tags = {
    Name = "web"
  }
}

resource "null_resource" "null" {
  count = 1
  depends_on = [aws_instance.web]

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = "${file("deployer")}"
      host     = "${element(aws_instance.web.*.public_ip,count.index)}"
    }
    inline = [
      "sudo amazon-linux-extras install epel -y" ,
      "sudo yum install mariadb git ansible -y",
      "sudo amazon-linux-extras install ansible2 -y",
      "ansible-pull  -U https://github.com/chandralekhasingasani/practice.git deploy.yml -e DBHOST=${var.DBHOST} -e DBPASS=${var.DBPASS} -e DBUSER=${var.DBUSER} -e IPADDRESS=$(curl -s ifconfig.me)"
    ]
  }
}
