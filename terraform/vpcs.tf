## VPCs and subnets

resource "aws_vpc" "r1" {
  provider = "aws.region1"
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "r2" {
  provider = "aws.region2"
  cidr_block = "10.1.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "r1" {
  provider = "aws.region1"
  vpc_id = "${aws_vpc.r1.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  provider = "aws.region1"
  route_table_id         = "${aws_vpc.r1.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.r1.id}"
}

################### START VPC inter region PEERING

resource "aws_vpc_peering_connection" "r1_to_r2_requester" {
  provider = "aws.region1"
  vpc_id        = "${aws_vpc.r1.id}"
  peer_vpc_id   = "${aws_vpc.r2.id}"
  peer_region   = var.region2
  auto_accept   = false
  tags = { Side = "Requester" }
}

# Accepter's side of the connection.
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

#################### END Inter region peering

resource "aws_subnet" "r1_az1" {
  provider = "aws.region1"
  vpc_id = "${aws_vpc.r1.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${data.aws_availability_zones.r1.names[0]}"
}

resource "aws_subnet" "r1_az2" {
  provider = "aws.region1"
  vpc_id = "${aws_vpc.r1.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${data.aws_availability_zones.r1.names[1]}"
}

resource "aws_subnet" "r1_az3" {
  provider = "aws.region1"
  vpc_id = "${aws_vpc.r1.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${data.aws_availability_zones.r1.names[2]}"
}

resource "aws_subnet" "r2_az1" {
  provider = "aws.region2"
  vpc_id = "${aws_vpc.r2.id}"
  cidr_block = "10.1.0.0/24"
  availability_zone = "${data.aws_availability_zones.r2.names[0]}"
}