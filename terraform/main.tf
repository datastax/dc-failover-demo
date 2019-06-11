provider "aws" {
  alias = "region1"
  region = var.region1
}

provider "aws" {
  alias = "region2"
  region = var.region2
}

data "aws_availability_zones" "r1" {
  provider = "aws.region1"
}

data "aws_availability_zones" "r2" {
  provider = "aws.region2"
}

data "aws_caller_identity" "current" {
  provider = "aws.region1"
}

resource "aws_vpc" "r1" {
  provider = "aws.region1"
  cidr_block = "10.0.0.0/16"
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

resource "aws_instance" "service_instance_1" {
  provider = "aws.region1"
  ami = var.amis[var.region1]
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.r1_az1.id}"
}

resource "aws_instance" "service_instance_2" {
  provider = "aws.region1"
  ami = var.amis[var.region1]
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.r1_az2.id}"
}


resource "aws_instance" "service_instance_3" {
  provider = "aws.region1"
  ami = var.amis[var.region1]
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.r1_az3.id}"
}

resource "aws_eip" "ip1" {
  provider = "aws.region1"
  instance = aws_instance.service_instance_1.id
}

#resource "aws_instance" "example2" {
#  provider = "aws.region2"
#  ami = var.amis[var.region2]
#  instance_type = "t2.micro"
#}
#
#resource "aws_eip" "ip2" {
#  provider = "aws.region2"
#  instance = aws_instance.example2.id
#}
#
#resource "aws_eip" "ip2" {
#  provider = "aws.region2"
#  instance = aws_instance.example2.id
#}


#resource "aws_globalaccelerator_accelerator" "demo_accelerator" {
#  name = "demo-accelerator"
#  ip_address_type = "IPV4"
#  enabled = true
#  # any of the two providers (the provider will be used but not the region itself)
#  provider = "aws.region1"
#}