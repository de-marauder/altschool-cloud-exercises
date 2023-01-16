resource "aws_subnet" "altschool-pub-subnet-1" {
  vpc_id                  = aws_vpc.altschool-vpc.id
  cidr_block              = var.subnet_pub_1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "altschool-pub-subnet-1"
  }
}
resource "aws_subnet" "altschool-pub-subnet-2" {
  vpc_id                  = aws_vpc.altschool-vpc.id
  cidr_block              = var.subnet_pub_2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "altschool-pub-subnet-2"
  }
}
resource "aws_subnet" "altschool-priv-subnet-1" {
  vpc_id     = aws_vpc.altschool-vpc.id
  cidr_block = var.subnet_priv_1_cidr
  availability_zone = var.az1

  tags = {
    Name = "altschool-priv-subnet-1"
  }
}
resource "aws_subnet" "altschool-priv-subnet-2" {
  vpc_id     = aws_vpc.altschool-vpc.id
  cidr_block = var.subnet_priv_2_cidr
  availability_zone = var.az2

  tags = {
    Name = "altschool-priv-subnet-2"
  }
}
