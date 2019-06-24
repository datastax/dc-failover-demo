provider "aws" {
  alias = "region1"
  region = var.region1
  version = "~> 2.16"
}

provider "aws" {
  alias = "region2"
  region = var.region2
  version = "~> 2.16"
}

provider "aws" {
  # Add a default one
  region = var.region1
}

provider "tls" {
  version = "~> 2.0"
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

data "aws_ami" "cassandra_r1" {
  provider = "aws.region1"
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["cassandra-image*"]
  }
}

data "aws_ami" "cassandra_r2" {
  provider = "aws.region2"
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["cassandra-image*"]
  }
}

data "aws_ami" "ami_web_r1" {
  provider = "aws.region1"
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["demo-web-image*"]
  }
}

data "aws_ami" "ami_web_r2" {
  provider = "aws.region2"
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["demo-web-image*"]
  }
}

resource "tls_private_key" "dev" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_r1" {
  provider = "aws.region1"
  key_name   = "dev_key_r1"
  public_key = "${tls_private_key.dev.public_key_openssh}"
}

resource "aws_key_pair" "key_r2" {
  provider = "aws.region2"
  key_name   = "dev_key_r2"
  public_key = "${tls_private_key.dev.public_key_openssh}"
}