##################################################
### Bastion in Region1 with connectivity
### to the rest of the nodes in each region
##################################################

resource "aws_instance" "bastion_r1" {
  provider = "aws.region1"
  ami = "${data.aws_ami.cassandra_r1.id}"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.r1_az1.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.key_r1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.sg_default_r1.id}", "${aws_security_group.sg_bastion_r1.id}"]
}
