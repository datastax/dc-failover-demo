#output "address" {
#  # value = "${aws_elb.web.dns_name}"
#  value = aws_globalaccelerator_accelerator.demo_accelerator.ip_sets[0]["ip_addresses"]
#}

output "private_key" {
  value = tls_private_key.dev.private_key_pem
}

output "bastion_r1_ip" {
  value = "${aws_instance.bastion_r1.public_ip}"
}