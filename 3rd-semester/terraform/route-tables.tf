resource "aws_route_table" "altschool-rtb-igw" {
  vpc_id = aws_vpc.altschool-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.altschool-igw.id
  }

  tags = {
    Name = "altschool-rtb-igw"
  }
}

resource "aws_route_table" "altschool-rtb-nat" {
  vpc_id = aws_vpc.altschool-vpc.id

  route {
    # cidr_block = var.vpc_cidr
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.altschool-nat.id
  }

  tags = {
    Name = "altschool-rtb-nat"
  }
}

resource "aws_route_table_association" "altschool-rtb-pub-assoc" {
  subnet_id      = aws_subnet.altschool-pub-subnet-1.id
  route_table_id = aws_route_table.altschool-rtb-igw.id
}

resource "aws_route_table_association" "altschool-rtb-priv-assoc" {
  subnet_id      = aws_subnet.altschool-priv-subnet-1.id
  route_table_id = aws_route_table.altschool-rtb-nat.id
}