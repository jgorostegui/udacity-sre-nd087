output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_security_group_id" {
  description = "ID of the ALB's security group"
  value       = aws_security_group.alb_sg.id
} 