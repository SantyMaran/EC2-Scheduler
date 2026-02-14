output "start_schedule" {
  value = aws_scheduler_schedule.start_ec2.name
}

output "stop_schedule" {
  value = aws_scheduler_schedule.stop_ec2.name
}
