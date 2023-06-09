#Resource to create a SSH private key via terraform
#Note: Donot use this in PROD as the private key generated by tls_private_key is stored 
##unencrypted in your terraform state file which is unsafe
resource "tls_private_key" "automateinfra_private_key" {
  #can be RSA, ECDSA or ED25519
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Resource to Create Key Pair
resource "aws_key_pair" "automateinfra_public_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.automateinfra_private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.automateinfra_private_key.private_key_pem}' > ./${var.key_pair_name}.pem"
  }
}
