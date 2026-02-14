# Use existing IAM Role
data "aws_iam_role" "ec2_start_stop_role" {
  name = "ec2-start-stop-role"
}

# Attach policy to existing role
resource "aws_iam_role_policy" "scheduler_policy" {
  name = "ec2-start-stop-policy"
  role = data.aws_iam_role.ec2_start_stop_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ]
      Resource = "arn:aws:ec2:ap-south-1:*:instance/${var.instance_id}"
    }]
  })
}

# START EC2
resource "aws_scheduler_schedule" "start_ec2" {
  name = "daily-ec2-start"

  schedule_expression = "cron(35 2 * * ? *)"
  schedule_expression_timezone = "Asia/Kolkata"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = data.aws_iam_role.ec2_start_stop_role.arn

    input = jsonencode({
      InstanceIds = [var.instance_id]
    })
  }
}

# STOP EC2
resource "aws_scheduler_schedule" "stop_ec2" {
  name = "daily-ec2-stop"

  schedule_expression = "cron(35 6 * * ? *)"   # 4 hours after 2:35 AM

  schedule_expression_timezone = "Asia/Kolkata"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = data.aws_iam_role.ec2_start_stop_role.arn

    input = jsonencode({
      InstanceIds = [var.instance_id]
    })
  }
}
