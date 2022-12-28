resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.generated_key.private_key_pem
  filename        = format("%s/%s/%s", abspath(path.root), ".ssh", "${var.resource_prefix}_ssh_key.pem")
  file_permission = "0600"
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
    ip          = aws_instance.s0_m1_ec2.public_ip,
    ssh_keyfile = local_sensitive_file.private_key.filename
  })
  filename = format("%s/%s", abspath(path.root), "inventory.yaml")
}