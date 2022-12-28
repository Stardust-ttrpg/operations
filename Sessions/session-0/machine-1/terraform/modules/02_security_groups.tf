resource "aws_security_group" "ec2_security_group" {
  name        = "${var.resource_prefix}-ec2-sg"
  description = "SG for ${var.resource_prefix}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.resource_prefix}-ec2-sg"
  }
}