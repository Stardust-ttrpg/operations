// generates a ssh key pair
resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Creates an ec2 key pair using the tls_private_key.generated_key public key
resource "aws_key_pair" "deployer" {
  key_name   = "${var.resource_prefix}-ec2-key-pair-${var.unique_id}"
  public_key = tls_private_key.generated_key.public_key_openssh
}

// Creates a secret manager secret for the operations_stackstorm public key
resource "aws_secretsmanager_secret" "keys_sm_secret" {
   name = "${var.resource_prefix}-keys-${var.unique_id}"
}
 
resource "aws_secretsmanager_secret_version" "keys_sm_secret_version" {
  secret_id = aws_secretsmanager_secret.keys_sm_secret.id
  secret_string = <<EOF
   {
    "key": "public_key",
    "value": "${sensitive(tls_private_key.generated_key.public_key_openssh)}"
   },
   {
    "key": "private_key",
    "value": "${sensitive(tls_private_key.generated_key.private_key_openssh)}"
   }
EOF
}