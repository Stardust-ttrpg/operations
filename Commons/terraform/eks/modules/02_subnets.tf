# Public Subnets
resource "aws_subnet" "Stardust-Public-Subnets" {
    count = var.availability_zones_count

    vpc_id          = aws_vpc.Stardust-vpc.id
    cidr_block      = cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, count.index)
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Public-Subnet-${count.index}"
      }
  )
}

# Private Subnets
resource "aws_subnet" "Stardust-Private-Subnets" {
  count = var.availability_zones_count

  vpc_id            = aws_vpc.Stardust-vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Private-Subnet-${count.index}"
      })
}