output "load_client_url_region1" {
  value = "http://${aws_instance.client_r1.public_ip}:8089"
}

output "load_client_url_region2" {
  value = "http://${aws_instance.client_r2.public_ip}:8089"
}

output "accelerator_public_ips" {
  value = aws_globalaccelerator_accelerator.demo_acc.ip_sets[0]["ip_addresses"]
}

output "accelerator_url1" {
  value = "http://${aws_globalaccelerator_accelerator.demo_acc.ip_sets[0]["ip_addresses"][0]}"
}

output "private_key" {
  value = tls_private_key.dev.private_key_pem
}

output "bastion_r1_ip" {
  value = "${aws_instance.bastion_r1.public_ip}"
}