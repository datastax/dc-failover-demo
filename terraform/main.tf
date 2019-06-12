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

resource "tls_private_key" "dev" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  provider = "aws.region1"
  key_name   = "dev_key"
  public_key = "${tls_private_key.dev.public_key_openssh}"
}

## Backing up

#resource "aws_globalaccelerator_accelerator" "demo_accelerator" {
#  name = "demo-accelerator"
#  ip_address_type = "IPV4"
#  enabled = true
#  # any of the two providers (the provider will be used but not the region itself)
#  provider = "aws.region1"
#}