resource "aws_instance" "i_web_r1_i1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.ami_web_r1.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r1_az1.id}"
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_default_r1.id}"]

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "sudo service nginx start",
    ]
  }
}