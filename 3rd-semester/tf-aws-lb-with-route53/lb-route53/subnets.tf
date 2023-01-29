resource "aws_subnet" "altschool-pub-subnet" {
  for_each = var.subnet_cidr

  vpc_id                  = aws_vpc.altschool-vpc.id
  cidr_block              = var.subnet_cidr[each.key]
  availability_zone       = var.az[each.key] # possible bug when "az.length !== subnet_cidr.length"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.subnet_name_tag}-${each.key}"
  }
}
