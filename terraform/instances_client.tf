##################################################
### Load clients in Regions 1 and 2
##################################################

resource "aws_instance" "client_r1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.ami_client_r1.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r1_az1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_client_r1.id}"]

  provisioner "remote-exec" {
    connection {
      host = aws_instance.client_r1.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "nohup ./start_client.sh ${aws_globalaccelerator_accelerator.demo_acc.ip_sets[0]["ip_addresses"][0]} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "client_r2" {
  provider = "aws.region2"
  ami = "${data.aws_ami.ami_client_r2.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r2_az1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.key_r2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_client_r2.id}"]

  provisioner "remote-exec" {
    connection {
      host = aws_instance.client_r2.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "nohup ./start_client.sh ${aws_globalaccelerator_accelerator.demo_acc.ip_sets[0]["ip_addresses"][1]} &",
      "sleep 5s"
    ]
  }
}
