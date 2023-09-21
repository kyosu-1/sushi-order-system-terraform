## VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.app_name}-vpc"
  }
}

## Subnets
### Public Subnets
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    "Name" = "${var.app_name}-${each.key}"
  }
}

### Subnets for AppRunner
resource "aws_subnet" "apprunner" {
  for_each = var.apprunner_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    "Name" = "${var.app_name}-${each.key}"
  }
}

### Subnets for Aurora
resource "aws_subnet" "db" {
  for_each = var.db_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
  tags = {
    "Name" = "${var.app_name}-${each.key}"
  }
}

## IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "${var.app_name}-igw"
  }
}

## NATGW
resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public[var.natgw_subnet_name].id
  allocation_id = aws_eip.natgw_eip.id
  tags = {
    Name = "${var.app_name}_natgw"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "natgw_eip" {
  tags = {
    Name = "${var.app_name}_eip_natgw"
  }
  depends_on = [aws_internet_gateway.igw]
}

## Route Tables
### RT for public subnets (with IGW route)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-public"
  }
}

resource "aws_route" "public_igw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

### RT for private apprunner subnets (with NATGW route)
resource "aws_route_table" "private_apprunner" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-private-apprunner"
  }
}

resource "aws_route" "private_apprunner_natgw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_apprunner.id
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

resource "aws_route_table_association" "private_apprunner" {
  for_each = aws_subnet.apprunner

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_apprunner.id
}

### RT for private db subnets (only local route)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.app_name}-private-db"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}
