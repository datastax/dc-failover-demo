resource aws_globalaccelerator_accelerator demo_acc {
  name = "demo-accelerator-${random_id.id1.hex}"
  ip_address_type = "IPV4"
  enabled = true
}

resource aws_globalaccelerator_listener demo_acc_listener {
  accelerator_arn = aws_globalaccelerator_accelerator.demo_acc.id
  protocol = "TCP"

  port_range {
    from_port = 80
    to_port = 80
  }
}

resource aws_globalaccelerator_endpoint_group demo_acc_eg_r1 {
  provider = aws.region1
  listener_arn = aws_globalaccelerator_listener.demo_acc_listener.id
  health_check_interval_seconds = 10
  threshold_count = 2
  health_check_path = "/status"
  health_check_port = 80
  health_check_protocol = "HTTP"

  endpoint_configuration {
    endpoint_id = aws_lb.lb_r1.arn
    weight = 100
  }
}

resource aws_globalaccelerator_endpoint_group demo_acc_eg_r2 {
  provider = aws.region2
  listener_arn = aws_globalaccelerator_listener.demo_acc_listener.id
  health_check_interval_seconds = 10
  threshold_count = 2
  health_check_path = "/status"
  health_check_port = 80
  health_check_protocol = "HTTP"

  endpoint_configuration {
    endpoint_id = aws_lb.lb_r2.arn
    weight = 100
  }
}