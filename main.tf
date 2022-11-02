//declaring the Provider i am working with (the suppplier of the cloud)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

}

//creating a vpc:
resource "aws_vpc" "vpc" { //was called testing
  cidr_block = "192.168.1.0/24"
  tags = {
    "Name" = "IdanCohenZada-dev-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Idan's_igw"
  }
}


resource "aws_subnet" "IdanCohenZada-k8s-subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/27" //meaning the addresses are: 0-31
  tags = {
    "Name" = "IdanCohenZada-k8s-subnet"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

//Setting up the network interface for machines to come
resource "aws_network_interface" "myIntCard"{
  subnet_id = aws_subnet.IdanCohenZada-k8s-subnet.id
  private_ips = [ "192.168.1.10" ]

  tags = {
    "name" = "Idan'sIntCard"
  }
}




