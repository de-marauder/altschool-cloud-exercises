resource "aws_internet_gateway" "altschool-igw" {
  vpc_id = aws_vpc.altschool-vpc.id

  tags = {
    Name = var.igw_name_tag
  }
}

resource "aws_route_table" "altschool-rtb-igw" {
  vpc_id = aws_vpc.altschool-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.altschool-igw.id
  }

  tags = {
    Name = var.rtb_name_tag
  }
}

resource "aws_route_table_association" "altschool-rtb-pub-assoc" {
  for_each       = aws_subnet.altschool-pub-subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.altschool-rtb-igw.id
}
