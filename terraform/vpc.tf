#######################################
# VPC
#######################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#######################################
# Internet Gateway
#######################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#######################################
# Subnets
#######################################
# Public
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = "${var.region}${var.az1}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-a"
    Tier = "frontend"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = "${var.region}${var.az2}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-b"
    Tier = "frontend"
  }
}

# Private backend
resource "aws_subnet" "private_backend" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_backend_subnet_cidr
  availability_zone = "${var.region}${var.az1}"

  tags = {
    Name = "${var.project_name}-private-backend"
    Tier = "backend"
  }
}

# Private db
resource "aws_subnet" "private_db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidr
  availability_zone = "${var.region}${var.az2}"

  tags = {
    Name = "${var.project_name}-private-db"
    Tier = "db"
  }
}

#######################################
# Public Route Table
#######################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

#######################################
# NAT Gateway (for private subnets)
#######################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "${var.project_name}-natgw"
  }
}

#######################################
# Private Route Tables
#######################################
resource "aws_route_table" "rt_backend" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.project_name}-rt-backend"
  }
}

resource "aws_route_table" "rt_db" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "${var.project_name}-rt-db"
  }
}

resource "aws_route_table_association" "assoc_backend" {
  subnet_id      = aws_subnet.private_backend.id
  route_table_id = aws_route_table.rt_backend.id
}

resource "aws_route_table_association" "assoc_db" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.rt_db.id
}
