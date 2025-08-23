variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "IAC-3Tier"
}

variable "my_ip" {
  description = "Client CIDR allowed to access the ALB"
  type        = string
  default     = "98.87.1.149/32"
}

variable "key_name" {
  description = "Existing EC2 key pair name to SSH from your control node"
  type        = string
  default     = "login"
}

variable "instance_type" {
  description = "EC2 type"
  type        = string
  default     = "t3.micro"
}

variable "node_app_port" {
  description = "Container port exposed by Node.js app"
  type        = number
  default     = 3000
}

variable "az1" {
  description = "First Availability Zone suffix"
  type        = string
  default     = "a"
}

variable "az2" {
  description = "Second Availability Zone suffix (ALB needs >= 2 AZs)"
  type        = string
  default     = "b"
}

# Subnet CIDRs
variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_backend_subnet_cidr" {
  description = "CIDR block for backend subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_db_subnet_cidr" {
  description = "CIDR block for DB subnet"
  type        = string
  default     = "10.0.4.0/24"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the whole VPC"
  type        = string
  default     = "10.0.0.0/16"
}
