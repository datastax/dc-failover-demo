########################################################
### VPCs, VPC peering, route tables and internet gateway
########################################################

resource "aws_vpc" "r1" {
  provider = "aws.region1"
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Demo - VPC R1",
    Purpose = "Demo failover"
  }
}

resource "aws_vpc" "r2" {
  provider = "aws.region2"
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Demo - VPC R2",
    Purpose = "Demo failover"
  }
}

resource "aws_internet_gateway" "agw_r1" {
  provider = "aws.region1"
  vpc_id = "${aws_vpc.r1.id}"
  tags = {
    Name = "Demo - IG R1",
    Purpose = "Demo failover"
  }
}

resource "aws_route" "internet_access_r1" {
  provider = "aws.region1"
  route_table_id         = "${aws_vpc.r1.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.agw_r1.id}"
}

resource "aws_internet_gateway" "agw_r2" {
  provider = "aws.region2"
  vpc_id = "${aws_vpc.r2.id}"
  tags = { Name = "demo" }
}

resource "aws_route" "internet_access_r2" {
  provider = "aws.region2"
  route_table_id         = "${aws_vpc.r2.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.agw_r2.id}"
}

resource "aws_vpc_peering_connection" "r1_to_r2_requester" {
  provider = "aws.region1"
  vpc_id        = "${aws_vpc.r1.id}"
  peer_vpc_id   = "${aws_vpc.r2.id}"
  peer_region   = var.region2
  auto_accept   = false
  tags = { Side = "Requester" }
}

resource "aws_vpc_peering_connection_accepter" "r1_to_r2_accepter" {
  provider = "aws.region2"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.r1_to_r2_requester.id}"
  auto_accept = true
  tags = { Side = "Accepter" }
}

resource "aws_route" "route_r1" {
  provider = "aws.region1"
  route_table_id            = "${aws_vpc.r1.main_route_table_id}"
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.r1_to_r2_requester.id}"
}

resource "aws_route" "route_r2" {
  provider = "aws.region2"
  route_table_id            = "${aws_vpc.r2.main_route_table_id}"
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.r1_to_r2_requester.id}"
}