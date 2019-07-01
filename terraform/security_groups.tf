resource "aws_security_group" "sg_default_r1" {
  provider = "aws.region1"
  name        = "sg_demo_default_r1"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r1.id}"

  # SSH, HTTP and more from the VPCs
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_default_r2" {
  provider = "aws.region2"
  name        = "sg_demo_default_r2"
  description = "Used in the terraform demo region2"
  vpc_id      = "${aws_vpc.r2.id}"

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_r1_az3" {
  provider = "aws.region1"
  name        = "sg_demo_r1_az3"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r1.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_bastion_r1" {
  provider = "aws.region1"
  name        = "sg_demo_bastion_r1"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r1.id}"

  # SSH from the internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_client_r1" {
  provider = "aws.region1"
  name        = "sg_demo_client_r1"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r1.id}"

  # SSH from the internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Locust web interface from the internet
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_client_r2" {
  provider = "aws.region2"
  name        = "sg_demo_client_r2"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r2.id}"

  # SSH from the internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Locust web interface from the internet
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_elb_r1" {
  provider = "aws.region1"
  name        = "sg_elb_r1"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r1.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_elb_r2" {
  provider = "aws.region2"
  name        = "sg_elb_r2"
  description = "Used in the terraform demo"
  vpc_id      = "${aws_vpc.r2.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The following rule is created separately from the rest in order to allow to be removed in tests
resource "aws_security_group_rule" "sg_rule_default_r2_allow_all_internal" {
  provider = "aws.region2"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.sg_default_r2.id}"
}

# The following rule is created separately from the rest in order to allow to be removed in tests
resource "aws_security_group_rule" "sg_rule_elb_r2_allow_http" {
  provider = "aws.region2"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_elb_r2.id}"
}

# The following rule is created separately from the rest in order to allow to be removed in tests
resource "aws_security_group_rule" "sg_rule_sg_r1_az3_allow_all_internal" {
  provider = "aws.region1"
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.sg_r1_az3.id}"
}
