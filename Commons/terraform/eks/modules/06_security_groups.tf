# Security group for public subnet
resource "aws_security_group" "Stardust-Public-SG" {
  name   =  "${var.resource_prefix}-Public-sg"
  vpc_id = aws_vpc.Stardust-vpc.id

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Public-SG"
      })
}

# Security group traffic rules
resource "aws_security_group_rule" "Stardust-Ingress-Public-443" {
  security_group_id = aws_security_group.Stardust-Public-SG.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "Stardust-Ingress-Public-80" {
  security_group_id = aws_security_group.Stardust-Public-SG.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "Stardust-Egress-Public" {
  security_group_id = aws_security_group.Stardust-Public-SG.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for workers (data plane)
resource "aws_security_group" "Stardust-Worker-SG" {
  name   =  "${ var.resource_prefix }-Worker-sg"
  vpc_id = aws_vpc.Stardust-vpc.id

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Worker-SG"
      })
}

# Security group traffic rules
resource "aws_security_group_rule" "Stardust-Nodes-GR" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.Stardust-Worker-SG.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "Stardust-Nodes-Inbound-GR" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.Stardust-Worker-SG.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "Stardust-Nodes-Outbound-GR" {
  security_group_id = aws_security_group.Stardust-Worker-SG.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for Orchestrator (controller plane)
resource "aws_security_group" "Stardust-Controller-Control-SG" {
  name   = "${ var.resource_prefix }-ControlPlane-sg"
  vpc_id = aws_vpc.Stardust-vpc.id

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-ControlPlane-SG"
      })
}

# Security group traffic rules
resource "aws_security_group_rule" "Stardust-Controller-Inbound-GR" {
  security_group_id = aws_security_group.Stardust-Controller-Control-SG.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 0), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 1), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 2), cidrsubnet(var.vpc_cidr_block, var.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "Stardust-Controller-Outbound-GR" {
  security_group_id = aws_security_group.Stardust-Controller-Control-SG.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}