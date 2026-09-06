
data "aws_availability_zones" "available" {
  state = "available"
}

output "available_azs" {
  value = slice(data.aws_availability_zones.available.names, 0, 3)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = merge(var.tags, {
    Name = "${var.company}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = "${var.company}-igw"
  })
}

resource "aws_subnet" "public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "public_subnet-${count.index + 1}"
  })
}

resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "aws_nat_gateway_eip"
  })
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public_subnet[0].id
  allocation_id = aws_eip.nat_gw_eip.id
  tags = merge(var.tags, {
    Name = "aws_nat_gw"
  })
}

resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(var.tags, {
    Name = "Private_subnet-${count.index + 1}"
  })
}
#############################################################################################
resource "aws_lb" "nlb" {
  name               = "${var.project_name}-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets                    = var.public_subnet[*].id
  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-lb"
  })

}

resource "aws_lb_target_group" "aws_lb" {
  name = "${var.project_name}-tg"
  port = "80"
  protocol = "TCP"
  target_type = "instance"

  health_check {
    enabled = true
    protocol = "TCP"
    port = "traffic-port"
  }


}

  

#############################################################################################