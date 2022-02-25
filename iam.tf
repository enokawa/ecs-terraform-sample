data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
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
