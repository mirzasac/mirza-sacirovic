#AWS VPC
resource "aws_vpc" "mirzasa-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
      Name = "mirzasa VPC"
      Description = "Srdjanov VPC"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "mirzasa-internet-gateway" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  tags = {
      Name = "mirzasa Internet Gateway"
  }
}
#Subnets
#Public Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  cidr_block = "10.0.10.0/24"
  availability_zone = "${var.region}a"
  tags = {
      Name = "mirzasa Public Subnet #1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  cidr_block = "10.0.20.0/24"
  availability_zone = "${var.region}b"
  tags = {
      Name = "mirzasa Public Subnet #2"
  }
}
#Private Subnets
resource "aws_subnet" "private-subnet-1" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  cidr_block = "10.0.30.0/24"
  availability_zone = "${var.region}a"
  tags = {
      Name = "mirzasa Private Subnet #1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  cidr_block = "10.0.40.0/24"
  availability_zone = "${var.region}b"
  tags = {
      Name = "mirzasa Private Subnet #2"
  }
}
#Routing Tables
#Public Subnets Routing Tables
resource "aws_route_table" "public-subnets-route-table" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.mirzasa-internet-gateway.id}"
  }
  tags = {
      Name = "mirzasa Public Subnets Routing Table"
  }
}
#Private Subnets Routing Tables
resource "aws_route_table" "private-subnets-route-table" {
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  tags = {
      Name = "mirzasa Private Subnets Routing Table"
  }
}
#Routing Table Associations
#Public Subnet Associations
resource "aws_route_table_association" "public-subnet-1-association" {
  subnet_id = "${aws_subnet.public-subnet-1.id}"
  route_table_id = "${aws_route_table.public-subnets-route-table.id}"
}
resource "aws_route_table_association" "public-subnet-2-association" {
  subnet_id = "${aws_subnet.public-subnet-2.id}"
  route_table_id = "${aws_route_table.public-subnets-route-table.id}"
}
#Private Subnet Associations
resource "aws_route_table_association" "private-subnet-1-association" {
  subnet_id = "${aws_subnet.private-subnet-1.id}"
  route_table_id = "${aws_route_table.private-subnets-route-table.id}"
}
resource "aws_route_table_association" "private-subnet-2-association" {
  subnet_id = "${aws_subnet.private-subnet-2.id}"
  route_table_id = "${aws_route_table.private-subnets-route-table.id}"
}
#Elastic IPs
# resource "aws_eip" "eip-1" {
#   vpc = true
#   tags = {
#       Name = "mirzasa Ellastic IP for NAT Gateway #1"
#   }
# }
# resource "aws_eip" "eip-2" {
#   vpc = true
#   tags = {
#       Name = "mirzasa Ellastic IP for NAT Gateway #2"
#   }
# }
# resource "aws_eip" "ec2-eip" {
#   vpc = true
#   tags = {
#     Name = "mirzasa Ellastic IP for EC2 Instance"
#   }
# }
# #NAT Gateways
# resource "aws_nat_gateway" "nat-gateway-1" {
#   subnet_id = "${aws_subnet.public-subnet-1.id}"
#   allocation_id = "${aws_eip.eip-1.id}"
#   tags = {
#       Name = "mirzasa NAT Gateway #1"
#   }
# }
# resource "aws_nat_gateway" "nat-gateway-2" {
#   subnet_id = "${aws_subnet.public-subnet-2.id}"
#   allocation_id = "${aws_eip.eip-2.id}"
#   tags = {
#       Name = "mirzasa NAT Gateway #2"
#   }
# }