resource "aws_instance" "bastion_r1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "m5.2xlarge"
  subnet_id = "${aws_subnet.r1_az1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}", "${aws_security_group.bastion_r1.id}"]
}

resource "aws_instance" "i_cassandra_r1_i1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "m5.2xlarge"
  subnet_id = "${aws_subnet.r1_az1.id}"
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      #"./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip},${aws_instance.i_cassandra_r2_i1.private_ip}",
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip}",
      "nohup ddac-*/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}

resource "aws_instance" "i_cassandra_r2_i1" {
  provider = "aws.region2"
  ami = "${data.aws_ami.cassandra_r2.id}"
  instance_type = "m5.2xlarge"
  subnet_id = "${aws_subnet.r2_az1.id}"
  key_name = "${aws_key_pair.key_r2.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r2.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip},${aws_instance.i_cassandra_r2_i1.private_ip}",
      "nohup ddac-*/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}

######################
## Rest of the nodes
######################

resource "aws_instance" "i_cassandra_r1_i2" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "m5.2xlarge"
  subnet_id = "${aws_subnet.r1_az2.id}"
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip},${aws_instance.i_cassandra_r2_i1.private_ip}",
      "nohup ddac-*/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}

resource "aws_instance" "i_cassandra_r1_i3" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "m5.2xlarge"
  subnet_id = "${aws_subnet.r1_az3.id}"
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default_r1.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip},${aws_instance.i_cassandra_r2_i1.private_ip}",
      "nohup ddac-*/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}