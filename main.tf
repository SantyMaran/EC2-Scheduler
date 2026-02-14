#IAM Role for Scheduler
resource "aws_iam_role" "scheduler_role" {
  name = "ec2-start-stop-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#Policy (Allow EC2 control)
resource "aws_iam_role_policy" "scheduler_policy" {
  name = "ec2-start-stop-policy"
  role = aws_iam_role.scheduler_role.id

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

