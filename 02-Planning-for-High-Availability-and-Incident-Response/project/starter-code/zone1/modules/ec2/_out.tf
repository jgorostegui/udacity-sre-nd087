output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.ubuntu[*].id
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}