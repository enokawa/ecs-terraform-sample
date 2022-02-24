resource "aws_security_group" "alb" {
  name        = "${var.stage}-alb-sg"
  description = "${var.stage}-alb-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.stage}-alb-sg"
  }
}

resource "aws_security_group_rule" "alb_ingress_80" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "ecs_app" {
  name        = "${var.stage}-app-sg"
  description = "${var.stage}-app-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "${var.stage}-app-sg"
  }
}

resource "aws_security_group_rule" "ecs_app_ingress_80" {
  security_group_id = aws_security_group.ecs_app.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"

  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_app_egress_all" {
  security_group_id = aws_security_group.ecs_app.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
