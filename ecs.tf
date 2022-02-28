resource "aws_ecs_cluster" "app" {
  name = "${var.stage}-app"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.stage}-app"
  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.stage}-app"
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2

  network_configuration {
    subnets = [
      aws_subnet.app_a.id,
      aws_subnet.app_b.id,
      aws_subnet.app_c.id
    ]
    security_groups  = [aws_security_group.ecs_app.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  enable_execute_command = true

  tags = {
    Name = "${var.stage}-app"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.stage}-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "public.ecr.aws/nginx/nginx:latest"
      essential = true
      linuxParameters = {
        "initProcessEnabled" = true
      }
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.stage}-app"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${var.stage}-app"
  }
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.stage}-app"
  retention_in_days = 1

  tags = {
    Name = "/ecs/${var.stage}-app"
  }
}
