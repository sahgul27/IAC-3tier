# Frontend public IP (ALB points here)
output "frontend_public_ip" {
  description = "Public IP of the frontend EC2"
  value       = aws_instance.frontend.public_ip
}

# Backend private IP
output "backend_private_ip" {
  description = "Private IP of the backend EC2"
  value       = aws_instance.backend.private_ip
}

# DB private IP
output "db_private_ip" {
  description = "Private IP of the database EC2"
  value       = aws_instance.db.private_ip
}

# ALB DNS
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}
