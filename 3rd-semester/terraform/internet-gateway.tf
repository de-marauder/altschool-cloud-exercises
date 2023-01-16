resource "aws_internet_gateway" "altschool-igw" {
  vpc_id = aws_vpc.altschool-vpc.id

  tags = {
    Name = "altschool-igw"
  }
}
