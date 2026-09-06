
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
  value     = tls_private_key.ec2_key.public_key_openssh
  sensitive = true
}
output "private_key" {
  value     = tls_private_key.ec2_key.private_key_openssh
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

  # -------------------------------------------------------
  # Install Nginx + Create Website at Startup
  # -------------------------------------------------------
  user_data = <<-EOF
    #!/bin/bash

    # Update packages
    apt-get update -y
    # Install Nginx
    apt-get install -y nginx

    # Create website
    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="en">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">

      <title>Priyanshu | Cloud & DevOps</title>

      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }

        body {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 30px;

          font-family: Arial, Helvetica, sans-serif;
          color: white;

          background:
            radial-gradient(
              circle at 15% 20%,
              #4f46e5,
              transparent 35%
            ),
            radial-gradient(
              circle at 85% 80%,
              #06b6d4,
              transparent 35%
            ),
            #020617;
        }

        .card {
          width: 100%;
          max-width: 850px;

          padding: 55px;

          text-align: center;

          background: rgba(255, 255, 255, 0.08);

          border: 1px solid rgba(255, 255, 255, 0.15);

          border-radius: 28px;

          backdrop-filter: blur(18px);

          box-shadow:
            0 25px 70px rgba(0, 0, 0, 0.45);
        }

        .profile {
          width: 120px;
          height: 120px;

          margin: 0 auto 25px;

          display: flex;
          align-items: center;
          justify-content: center;

          border-radius: 50%;

          font-size: 48px;
          font-weight: bold;

          background:
            linear-gradient(
              135deg,
              #6366f1,
              #06b6d4
            );

          box-shadow:
            0 10px 35px rgba(6, 182, 212, 0.35);
        }

        .status {
          display: inline-flex;
          align-items: center;
          gap: 8px;

          padding: 8px 16px;
          margin-bottom: 22px;

          border-radius: 50px;

          color: #86efac;

          background: rgba(34, 197, 94, 0.12);
        }

        .dot {
          width: 9px;
          height: 9px;

          border-radius: 50%;

          background: #22c55e;

          box-shadow:
            0 0 12px #22c55e;
        }

        h1 {
          font-size: 48px;
          margin-bottom: 12px;
        }

        .subtitle {
          font-size: 21px;
          color: #cbd5e1;
          margin-bottom: 30px;
        }

        .intro {
          max-width: 700px;

          margin: auto;

          line-height: 1.8;

          font-size: 17px;

          color: #e2e8f0;
        }

        .aws {
          color: #fbbf24;
          font-weight: bold;
        }

        .skills {
          display: flex;
          flex-wrap: wrap;

          justify-content: center;

          gap: 12px;

          margin-top: 35px;
        }

        .skill {
          padding: 10px 18px;

          border-radius: 50px;

          color: #e0f2fe;

          background: rgba(255,255,255,0.08);

          border: 1px solid rgba(255,255,255,0.15);
        }

        .footer {
          margin-top: 35px;

          color: #94a3b8;

          font-size: 14px;
        }

        @media (max-width: 600px) {
          .card {
            padding: 35px 22px;
          }

          h1 {
            font-size: 36px;
          }
        }
      </style>
    </head>

    <body>

      <div class="card">

        <div class="profile">
          P
        </div>

        <div class="status">
          <span class="dot"></span>
          Nginx Server Online
        </div>

        <h1>
          Hello, I'm Priyanshu 👋
        </h1>

        <div class="subtitle">
          Cloud & DevOps Enthusiast
        </div>

        <p class="intro">
          Welcome to my personal website!

          I am passionate about Cloud Computing,
          Infrastructure, Automation and DevOps.

          I am currently working with
          <span class="aws">AWS</span>,
          Terraform, Linux, Docker and
          modern cloud technologies.
        </p>

        <div class="skills">

          <div class="skill">
            ☁️ AWS
          </div>

          <div class="skill">
            ⚙️ Terraform
          </div>

          <div class="skill">
            🐧 Linux
          </div>

          <div class="skill">
            🐳 Docker
          </div>

          <div class="skill">
            🚀 DevOps
          </div>

          <div class="skill">
            🌐 Nginx
          </div>

        </div>

        <div class="footer">
          Deployed automatically using Terraform 🚀
        </div>

      </div>

    </body>
    </html>
    HTML

    # Make sure Nginx is enabled and running
    systemctl enable nginx
    systemctl restart nginx

  EOF

  tags = merge(var.tags, {
    Name = "web-ec2-${count.index + 1}"
  })

}