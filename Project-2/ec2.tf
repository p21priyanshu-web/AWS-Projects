
# ---------------------------------------------------------
# Latest Ubuntu AMI in current AWS region
# ---------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
# ---------------------------------------------------------
# Generate SSH Key
# ---------------------------------------------------------

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "public_key" {
  value = tls_private_key.ec2_key.public_key_openssh
  sensitive = true
}
output "private_key" {
  value = tls_private_key.ec2_key.private_key_openssh
  sensitive = true
}
# ---------------------------------------------------------
# Create AWS Key Pair
# ---------------------------------------------------------
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# ---------------------------------------------------------
# Save Private Key Locally
# ---------------------------------------------------------

resource "local_sensitive_file" "private_key" {
  filename        = "${path.module}/${var.key_name}.pem"
  content         = tls_private_key.ec2_key.private_key_openssh
  file_permission = "0600"
}

# ---------------------------------------------------------
# Launching EC2 Instances
# ---------------------------------------------------------
resource "aws_instance" "web-1-ec2" {
  count                  = 2
  subnet_id              = aws_subnet.private_subnets[count.index].id
  instance_type          = var.instance_type
  ami                    = data.aws_ami.ubuntu.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = false
  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
  tags = merge(var.tags, {
    Name = "web-ec2-${count.index + 1}"
  })

}