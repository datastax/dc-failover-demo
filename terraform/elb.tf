resource "aws_lb" "lb_r1" {
  provider = "aws.region1"
  name = "lb-demo-r1"
  load_balancer_type = "application"
  subnets = ["${aws_subnet.r1_az1.id}", "${aws_subnet.r1_az2.id}", "${aws_subnet.r1_az3.id}"]
  security_groups = ["${aws_security_group.sg_default_r1.id}", "${aws_security_group.sg_elb_r1.id}"]
  enable_cross_zone_load_balancing = true
  # TODO: Set to true once AWS Global Accelerator is terraformed
  internal = false
}

resource "aws_lb_target_group" "lb_tg_r1" {
  provider = "aws.region1"
  name = "lb-tg-demo-r1"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.r1.id}"
  target_type = "instance"

  health_check {
    interval = 5
    port = 8080
    path = "/status"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
  }
}

resource "aws_lb_target_group_attachment" "lb_tga_r1_i1" {
  provider = "aws.region1"
  target_group_arn = "${aws_lb_target_group.lb_tg_r1.arn}"
  target_id = "${aws_instance.i_web_r1_i1.id}"
  port = 8080
  #TODO: Add more target group attachments per web instance
}

resource "aws_lb_listener" "lb_r1_listener" {
  provider = "aws.region1"
  load_balancer_arn = "${aws_lb.lb_r1.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.lb_tg_r1.arn}"
  }
}