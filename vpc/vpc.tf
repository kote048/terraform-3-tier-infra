resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"}
  )
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet1_cidr_block
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet1"}
  )
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet2_cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone[1]
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet2"}
  )
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet1_cidr_block
  availability_zone = var.availability_zone[0]
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet1"}
  )
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet2_cidr_block
  availability_zone = var.availability_zone[1]
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet2"}
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-IGW"}
  )
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-Public-Route-table"}
  )

}



resource "aws_route_table_association" "public-subnet1-association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public-subnet2-association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-NAT-GW"})

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip, aws_subnet.public_subnet1]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = merge(var.tags, {Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-Private-Route-table"}
  )

}

resource "aws_route_table_association" "private-subnet1-association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private-subnet2-association" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

