# Route the public subnet traffic through the IGW
resource "aws_route_table" "Stardust-RT" {
  vpc_id = aws_vpc.Stardust-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Stardust-IGW.id
  }

  tags = {
    Name = "${ var.resource_prefix }-RT"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "Stardust-Internet-Access" {
  count = var.availability_zones_count
  subnet_id      = aws_subnet.Stardust-Private-Subnets[count.index].id
  route_table_id = aws_route_table.Stardust-RT.id
}