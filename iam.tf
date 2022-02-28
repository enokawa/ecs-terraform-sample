data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_exec_policy" {
  name        = "${var.stage}-ecs-exec-policy"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = {
    Name = "${var.stage}-ecs-exec-policy"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.stage}-ecs-task-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy.json

  tags = {
    Name = "${var.stage}-ecs-task-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
}

data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.stage}-ecs-task-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_policy.json

  tags = {
    Name = "${var.stage}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
