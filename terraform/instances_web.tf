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
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r1_i1.private_ip} ${aws_instance.i_cassandra_r1_i1.availability_zone} ${aws_instance.i_cassandra_r2_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "i_web_r1_i2" {
  provider = "aws.region1"
  ami = "${data.aws_ami.ami_web_r1.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r1_az2.id}"
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
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r1_i1.private_ip} ${aws_instance.i_cassandra_r1_i1.availability_zone} ${aws_instance.i_cassandra_r2_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "i_web_r1_i3" {
  provider = "aws.region1"
  ami = "${data.aws_ami.ami_web_r1.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r1_az3.id}"
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
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r1_i1.private_ip} ${aws_instance.i_cassandra_r1_i1.availability_zone} ${aws_instance.i_cassandra_r2_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "i_web_r2_i1" {
  provider = "aws.region2"
  ami = "${data.aws_ami.ami_web_r2.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r2_az1.id}"
  key_name = "${aws_key_pair.key_r2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_default_r2.id}"]

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r2_i1.private_ip} ${aws_instance.i_cassandra_r2_i1.availability_zone} ${aws_instance.i_cassandra_r1_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "i_web_r2_i2" {
  provider = "aws.region2"
  ami = "${data.aws_ami.ami_web_r2.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r2_az2.id}"
  key_name = "${aws_key_pair.key_r2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_default_r2.id}"]

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r2_i1.private_ip} ${aws_instance.i_cassandra_r2_i1.availability_zone} ${aws_instance.i_cassandra_r1_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}

resource "aws_instance" "i_web_r2_i3" {
  provider = "aws.region2"
  ami = "${data.aws_ami.ami_web_r2.id}"
  instance_type = "m5.large"
  subnet_id = "${aws_subnet.r2_az3.id}"
  key_name = "${aws_key_pair.key_r2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_default_r2.id}"]

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "nohup ./start_web.sh ${aws_instance.i_cassandra_r2_i1.private_ip} ${aws_instance.i_cassandra_r2_i1.availability_zone} ${aws_instance.i_cassandra_r1_i1.availability_zone} &",
      "sleep 5s"
    ]
  }
}