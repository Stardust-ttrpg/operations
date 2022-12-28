resource "aws_vpc" "Stardust-vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "${ var.resource_prefix }-VPC"
  }
}