# resource "aws_network_interface" "s0_m1_network_interface" {
#   subnet_id   = data.aws_subnet.selected.id

#   tags = {
#     Name = "${var.resource_prefix}_primary_network_interface"
#   }
# }

resource "aws_instance" "s0_m1_ec2" {
  ami                   = data.aws_ami.ubuntu.id
  instance_type         = var.instance_type
  key_name              = aws_key_pair.deployer.id
  security_groups       = [aws_security_group.ec2_security_group.name]
  iam_instance_profile  = aws_iam_instance_profile.ec2_profile.name
  monitoring            = true
  
  root_block_device {
    volume_size   = var.volume_size
  }

  # network_interface {
  #   network_interface_id = aws_network_interface.s0_m1_network_interface.id
  #   device_index         = 0
  # }

  tags = {
    Name = "${var.resource_prefix}_s0_m1_ec2"
  }
}