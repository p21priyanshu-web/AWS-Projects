resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = "default"

  tags = {
    Name       = var.vpc_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_subnet" "pub-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.public_subnet_az_1
  map_public_ip_on_launch = true
  tags = {
    Name       = var.public_subnet_1_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.public_subnet_az_2
  map_public_ip_on_launch = true
  tags = {
    Name       = var.public_subnet_1_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_subnet" "pri-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1_cidr
  availability_zone       = var.public_subnet_az_1
  map_public_ip_on_launch = false
  tags = {
    Name       = var.private_subnet_1_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_subnet" "pri-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_2_cidr
  availability_zone       = var.public_subnet_az_1
  map_public_ip_on_launch = false
  tags = {
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name : var.igw_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_route_table" "public_route_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name       = var.public_rt_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.public_route_1.id

}
resource "aws_route_table_association" "public_rt_asso-2" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.public_route_1.id

}

resource "aws_eip" "ip_1" {
  domain = "vpc"
  tags = {
    Name       = var.eip_1_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}
resource "aws_eip" "ip_2" {
  domain = "vpc"
  tags = {
    Name       = var.eip_2_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}
resource "aws_nat_gateway" "nat_g_1" {
  allocation_id = aws_eip.ip_1.id
  subnet_id     = aws_subnet.pub-subnet-1.id
  tags = {
    Name       = var.nat_gw_name_1
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
  depends_on = [aws_internet_gateway.main]
}
resource "aws_nat_gateway" "nat_g_2" {
  allocation_id = aws_eip.ip_2.id
  subnet_id     = aws_subnet.pub-subnet-2.id
  tags = {
    Name       = var.nat_gw_name_2
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
  depends_on = [aws_internet_gateway.main]
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_g_1.id
  }

  tags = {
    Name       = var.private_rt_1_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_g_2.id
  }

  tags = {
    Name       = var.private_rt_2_name
    Name       = var.private_subnet_2_name
    Project    = var.project_name
    Managed_by = "terraform"
    Owner      = "Jiyna"
  }
}

resource "aws_route_table_association" "private_rt_1_asso" {
  subnet_id      = aws_subnet.pri-subnet-1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_rt_2_asso" {
  subnet_id      = aws_subnet.pri-subnet-2.id
  route_table_id = aws_route_table.private_2.id
}

