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

resource "aws_subnet" "r2_az2" {
  provider = "aws.region2"
  vpc_id = "${aws_vpc.r2.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "${data.aws_availability_zones.r2.names[1]}"
}

resource "aws_subnet" "r2_az3" {
  provider = "aws.region2"
  vpc_id = "${aws_vpc.r2.id}"
  cidr_block = "10.1.2.0/24"
  availability_zone = "${data.aws_availability_zones.r2.names[2]}"
}