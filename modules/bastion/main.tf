resource "aws_iam_role" "bastion_role" {
  name = "${var.app_name}-bastion-instance-profile-for-SSM"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${var.app_name}-profile"
  role = aws_iam_role.bastion_role.name
}

## Bastion Instance
resource "aws_instance" "bastion" {
  ami           = var.bastion_ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids      = [var.bastion_sg_id]
  subnet_id                   = var.bastion_subnet_id
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  associate_public_ip_address = "true"

  user_data = <<EOF
    #! /bin/bash
    yum update -y
    yum install -y mysql
  EOF

  tags = {
    Name = "${var.app_name}-bastion"
  }
}