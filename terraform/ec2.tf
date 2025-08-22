data "aws_ami" "al2023" {
owners = ["137112412989"] # Amazon
most_recent = true
filter {
name = "name"
values = ["al2023-ami-*-x86_64"]
}
}


resource "aws_iam_role_policy_attachment" "ssm_core" {
role = aws_iam_role.ssm_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ssm_profile" {
name = "${var.project_name}-ssm-profile"
role = aws_iam_role.ssm_role.name
}


# FRONTEND EC2 (public)
resource "aws_instance" "frontend" {
ami = data.aws_ami.al2023.id
instance_type = var.instance_type
subnet_id = aws_subnet.public_a.id
vpc_security_group_ids = [aws_security_group.frontend_sg.id]
key_name = var.key_name
iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
associate_public_ip_address = true


tags = { Name = "${var.project_name}-frontend" }
}


# BACKEND EC2 (private)
resource "aws_instance" "backend" {
ami = data.aws_ami.al2023.id
instance_type = var.instance_type
subnet_id = aws_subnet.private_backend.id
vpc_security_group_ids = [aws_security_group.backend_sg.id]
key_name = var.key_name
iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
associate_public_ip_address = false


tags = { Name = "${var.project_name}-backend" }
}


# DB EC2 (private)
resource "aws_instance" "db" {
ami = data.aws_ami.al2023.id
instance_type = var.instance_type
subnet_id = aws_subnet.private_db.id
vpc_security_group_ids = [aws_security_group.db_sg.id]
key_name = var.key_name
iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
associate_public_ip_address = false


tags = { Name = "${var.project_name}-db" }
}