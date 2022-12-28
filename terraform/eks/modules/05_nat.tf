# NAT Elastic IP
resource "aws_eip" "Stardust-EIP" {
  vpc = true

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-NGW-IP"
      })
}

# NAT Gateway
resource "aws_nat_gateway" "Stardust-NGW" {
  allocation_id = aws_eip.Stardust-EIP.id
  subnet_id     = aws_subnet.Stardust-Public-Subnets[0].id

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-NGW"
      })
}

# Add NAT endpoint to routing table
resource "aws_route" "main" {
  route_table_id         = aws_vpc.Stardust-vpc.default_route_table_id
  nat_gateway_id         = aws_nat_gateway.Stardust-NGW.id
  destination_cidr_block = "0.0.0.0/0"
}