resource "aws_elb" "elb_r1" {
  provider = "aws.region1"
  name = "elb-demo-r1"
  subnets = ["${aws_subnet.r1_az1.id}", "${aws_subnet.r1_az2.id}", "${aws_subnet.r1_az3.id}"]
  security_groups = ["${aws_security_group.sg_default_r1.id}", "${aws_security_group.sg_elb_r1.id}"]
  # TODO: Set to true once AWS Global Accelerator is terraformed
  internal = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    # TODO: use an specific path
#    target = "HTTP:8000/health_check"
    target              = "HTTP:80/"
    interval            = 10
  }

  instances = ["${aws_instance.i_web_r1_i1.id}"]
  cross_zone_load_balancing = true
  connection_draining = true
}