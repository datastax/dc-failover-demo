resource "aws_globalaccelerator_accelerator" "demo_acc" {
  provider = "aws.region1"
  name = "demo-accelerator"
  ip_address_type = "IPV4"
  enabled = true
}

resource "aws_globalaccelerator_listener" "demo_acc_listener" {
  provider = "aws.region1"
  accelerator_arn = "${aws_globalaccelerator_accelerator.demo_acc.id}"
  client_affinity = "SOURCE_IP"
  protocol = "TCP"

  port_range {
    from_port = 80
    to_port = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "demo_acc_eg_r1" {
  provider = "aws.region1"
  listener_arn = "${aws_globalaccelerator_listener.demo_acc_listener.id}"

  endpoint_configuration {
    endpoint_id = "${aws_lb.lb_r1.arn}"
    weight = 100
  }
}