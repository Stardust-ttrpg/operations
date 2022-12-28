resource "aws_internet_gateway" "Stardust-IGW" {
  vpc_id = aws_vpc.Stardust-vpc.id

  tags = {
    Name = "${ var.resource_prefix }-IGW"
  }
}