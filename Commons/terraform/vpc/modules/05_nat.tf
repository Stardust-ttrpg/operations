# # NAT Elastic IP
# resource "aws_eip" "Stardust-EIP" {
#   count = var.availability_zones_count
#   vpc = true
#   tags = {
#     Name = "${ var.resource_prefix }-NGW-IP"
#   }
# }

# NAT Gateway
# resource "aws_nat_gateway" "Stardust-NGW" {
#   count = var.availability_zones_count
#   allocation_id = aws_eip.Stardust-EIP[count.index].id
#   subnet_id     = aws_subnet.Stardust-Public-Subnets[count.index].id

#   tags = {
#     Name = "${ var.resource_prefix }-NGW-${count.index}"
#   }
# }

# Add NAT endpoint to routing table
# resource "aws_route" "main" {
#   count = var.availability_zones_count
#   route_table_id         = aws_vpc.Stardust-vpc.default_route_table_id
#   nat_gateway_id         = aws_nat_gateway.Stardust-NGW[count.index].id
#   //destination_cidr_block = "0.0.0.0/0"
# }