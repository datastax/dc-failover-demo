#output "address" {
#  # value = "${aws_elb.web.dns_name}"
#  value = aws_globalaccelerator_accelerator.demo_accelerator.ip_sets[0]["ip_addresses"]
#}