resource "aws_lb" "app" {
  name               = "${var.stage}-app"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
    aws_subnet.public_c.id
  ]

  enable_deletion_protection = false
  
  tags = {
    Name = "${var.stage}-app"
  }
}

resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = {
    Name = "${var.stage}-app-http-listener"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name        = "${var.stage}-app-lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  deregistration_delay = 60

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 10
    path                = "/"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.stage}-app-tg"
  }
}
