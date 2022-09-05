resource "aws_iam_role" "ecs_task_execution_role" {
  name = lower("${var.app_name}-ecs-task-execution-role")
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_task_role" {
  name = lower("${var.app_name}-ecs-task-role")
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
    inline_policy {
    name = "dynamo-access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "dynamodb:CreateTable",
            "dynamodb:UpdateTimeToLive",
            "dynamodb:PutItem",
            "dynamodb:DescribeTable",
            "dynamodb:DescribeGlobalTable",
            "dynamodb:ListTables",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query",
            "dynamodb:UpdateItem",
            "dynamodb:UpdateTable"
          ]
          Effect   = "Allow"
          Resource = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*",
            "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/*"
          ]
        }
      ]
    })
  }
}