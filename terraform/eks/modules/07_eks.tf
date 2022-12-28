# EKS Cluster
resource "aws_eks_cluster" "Stardust-Cluster" {
  name     = "${ var.resource_prefix }-Cluster"
  role_arn = aws_iam_role.Stardust-Cluser-Iam-Role.arn
  version  = "1.21"

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = flatten([aws_subnet.Stardust-Public-Subnets[*].id, aws_subnet.Stardust-Private-Subnets[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Cluster"
      })

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# EKS Cluster IAM Role
resource "aws_iam_role" "Stardust-Cluser-Iam-Role" {
  name = "${ var.resource_prefix }-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Stardust-Cluser-Iam-Role.name
}

# EKS Cluster Security Group
resource "aws_security_group" "Stardust-EKS-Cluster-SG" {
  name        = "${ var.resource_prefix }-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.Stardust-vpc.id

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Cluster-SG"
      })
}

# EKS Node Security Group
resource "aws_security_group" "Stardust-EKS-Node-SG" {
  name        = "${ var.resource_prefix }-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.Stardust-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
      var.common_tags,
      {
        Name = "${ var.resource_prefix }-Node-SG",
        "kubernetes.io/cluster/${var.cluster_prefix}-cluster" = "owned"
      })
}

resource "aws_security_group_rule" "Stardust-EKS-Cluster-Inbound-SGR" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.Stardust-EKS-Cluster-SG.id
  source_security_group_id = aws_security_group.Stardust-EKS-Node-SG.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "Stardust-EKS-Cluster-Outbound-SGR" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.Stardust-EKS-Cluster-SG.id
  source_security_group_id = aws_security_group.Stardust-EKS-Node-SG.id
  to_port                  = 65535
  type                     = "egress"
}
