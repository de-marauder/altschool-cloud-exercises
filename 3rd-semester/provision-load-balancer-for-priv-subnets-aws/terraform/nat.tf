resource "aws_nat_gateway" "altschool-nat" {
  allocation_id = aws_eip.altschool-eip.id
  subnet_id     = aws_subnet.altschool-pub-subnet-1.id

  tags = {
    Name = "altschool-nat"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.altschool-igw]
}