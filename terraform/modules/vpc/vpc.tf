#create vpc
resource "aws_vpc" "main" {
  cidr_block       = var.CIDR_BLOCK
  tags = {
    Name = "main"
  }
}

#create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

#create public subnets
resource "aws_subnet" "public-subnet" {
  count      = length(data.aws_availability_zones.available.names)
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.CIDR_BLOCK,8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names , count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.PROJECT_NAME}-PUBLIC-SUBNET-${count.index+1}"
  }
}

#associate route table to subnet
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_route_table_assoc" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public-subnet.*.id,count.index)
  route_table_id = aws_route_table.public-rt.id
}