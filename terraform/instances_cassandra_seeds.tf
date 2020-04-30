##################################
### Cassandra seed nodes
##################################

resource aws_instance i_cassandra_r1_i1 {
  provider = aws.region1
  ami = data.aws_ami.cassandra_r1.id
  instance_type = "m5.2xlarge"
  subnet_id = aws_subnet.r1_az1.id
  key_name = aws_key_pair.key_r1.key_name
  vpc_security_group_ids = [aws_security_group.sg_default_r1.id]
  tags = {
    Name = "Demo - Cassandra Node",
    Purpose = "Demo failover"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner remote-exec {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "echo \"${self.private_ip} ${self.private_dns}\" | sudo tee -a /etc/hosts",
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip}",
      "nohup cassandra/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}

resource aws_instance i_cassandra_r2_i1 {
  provider = aws.region2
  ami = data.aws_ami.cassandra_r2.id
  instance_type = "m5.2xlarge"
  subnet_id = aws_subnet.r2_az1.id
  key_name = aws_key_pair.key_r2.key_name
  vpc_security_group_ids = [aws_security_group.sg_default_r2.id]
  tags = {
    Name = "Demo - Cassandra Node",
    Purpose = "Demo failover"
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
    delete_on_termination = true
  }

  provisioner remote-exec {
    connection {
      bastion_host = aws_instance.bastion_r1.public_ip
      host = self.private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.dev.private_key_pem
    }

    inline = [
      "echo \"${self.private_ip} ${self.private_dns}\" | sudo tee -a /etc/hosts",
      "./generate_config.sh ${aws_instance.i_cassandra_r1_i1.private_ip},${aws_instance.i_cassandra_r2_i1.private_ip}",
      "nohup cassandra/bin/cassandra -p pid.txt &",
      "./wait_for_cassandra.sh"
    ]
  }
}