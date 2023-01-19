resource "aws_eip" "altschool-eip" {
  vpc = true

  depends_on = [aws_internet_gateway.altschool-igw]
}
