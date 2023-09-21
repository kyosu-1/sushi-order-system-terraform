## DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.app_name
  subnet_ids = var.db_subnet_ids
}

resource "aws_db_instance" "mysql_instance" {
  identifier             = var.app_name
  allocated_storage      = 5 # 最小のストレージサイズ
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro" # 最小のインスタンスタイプ
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.db_sg_id]
  multi_az               = false

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}
