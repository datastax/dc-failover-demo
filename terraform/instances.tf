#resource "aws_instance" "service_instance_r2_s1" {
#  provider = "aws.region2"
#  ami = var.amis[var.region2]
#  instance_type = "t2.micro"
#  subnet_id = "${aws_subnet.r2_az1.id}"
#}

resource "aws_instance" "bastion_r1" {
  provider = "aws.region1"
  ami = "ami-b374d5a5"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.r1_az1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}", "${aws_security_group.bastion_r1.id}"]

  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "echo 'Hello world' > temp-sample.txt"
    ]
  }
}

resource "aws_instance" "instance_r1_s1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.r1_az1.id}"
  key_name = "${aws_key_pair.generated_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}"]


  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "echo 'Hello world from service instance' > temp-sample.txt"
    ]
  }
}