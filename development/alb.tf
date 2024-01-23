resource "aws_lb_target_group" "my_app_eg1" {
  name       = "my-app-eg1"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = module.vpc.vpc_id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  # Enable health check if app has endpoint for it
  # health_check {
  #   enabled             = true
  #   port                = 8081
  #   interval            = 30
  #   protocol            = "HTTP"
  #   path                = "/health"
  #   matcher             = "200"
  #   healthy_threshold   = 3
  #   unhealthy_threshold = 3
  # }
}

resource "aws_lb_target_group_attachment" "my_app_eg1" {
  count            = length(module.compute.instance_ids)
  target_group_arn = aws_lb_target_group.my_app_eg1.arn
  target_id        = element(module.compute.instance_ids, count.index)
  # port             = 80
}

resource "aws_lb" "my_app_eg1" {
  name               = "my-app-eg1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg1.id]

  # access_logs {
  #   bucket  = "my-logs"
  #   prefix  = "my-app-lb"
  #   enabled = true
  # }

  subnets = module.vpc.public_subnet_ids
}


resource "aws_lb_listener" "http_eg1" {
  load_balancer_arn = aws_lb.my_app_eg1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_eg1.arn
  }
  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }

}

# resource "aws_lb_listener_rule" "static" {
#   listener_arn = aws_lb_listener.http_eg1.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_app_eg1.arn

#   }

#   condition {
#     path_pattern {
#       values = ["/var/www/html/index.html"]
#     }
#   }
# }


###################
