resource "aws_vpc" "Stardust-vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = merge(
    var.common_tags,
    {
        Name = "${ var.resource_prefix }-VPC"
    }
  )
}