resource "aws_lb" "app_alb" {
  name               = "tf-ebs-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg1" {
  name     = "tf-ebs-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "HTTP"
    path                = "/"
    port = "traffic-port"
    interval = 6
    timeout = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "tg2" {
  name     = "tf-ebs-tg2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    protocol = "HTTP"
    path                = "/"
    port = "traffic-port"
    interval = 6 #Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300.
    timeout = 5 #no response from a target means a failed health check. The range is 2–120
    healthy_threshold   = 2 #Number of consecutive health check successes required before considering a target healthy. The range is 2-10.
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port = "80"
  protocol = "HTTP"
default_action {
   type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
}
}
    
resource "aws_lb_listener_rule" "header_based_routing_example-1-tg1" {
  listener_arn = aws_lb_listener.http.arn
  priority = 1

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
  condition {
    # *.ndps.services
    query_string {
      key   = "merchId"
      value = "*"
    }

    query_string {
      key   = "login"
      value = "*"
    }
  }
}
resource "aws_lb_listener_rule" "header_based_routing_example-1-tg2" {
  listener_arn = aws_lb_listener.http.arn
  priority = 250

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg2.arn
  }
  condition {
    
    query_string {
      key   = "merchId"
      value = "*"
    }
    query_string {
      key   = "login"
      value = "*"
    }
  }
}
