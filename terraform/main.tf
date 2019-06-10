provider "aws" {
  alias = "region1"
  region = var.region1
}

provider "aws" {
  alias = "region2"
  region = var.region2
}

resource "aws_instance" "example1" {
  provider = "aws.region1"
  ami = var.amis[var.region1]
  instance_type = "t2.micro"
}

resource "aws_eip" "ip1" {
  instance = aws_instance.example1.id
  provider = "aws.region1"
}

resource "aws_instance" "example2" {
  provider = "aws.region2"
  ami = var.amis[var.region2]
  instance_type = "t2.micro"
}

resource "aws_eip" "ip2" {
  instance = aws_instance.example2.id
  provider = "aws.region2"
}

resource "aws_eip" "ip2" {
  instance = aws_instance.example2.id
  provider = "aws.region2"
}

resource "aws_globalaccelerator_accelerator" "demo_accelerator" {
  name = "demo-accelerator"
  ip_address_type = "IPV4"
  enabled = true
  # any of the two providers (the provider will be used but not the region itself)
  provider = "aws.region1"
}