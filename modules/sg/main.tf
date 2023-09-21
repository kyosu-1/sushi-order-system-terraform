## SG
### SG for App Runner ENI
resource "aws_security_group" "apprunner_sg" {
  name   = "${var.app_name}-apprunner-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "apprunner_sg_egress" {
  security_group_id = aws_security_group.apprunner_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

## SG for Aurora Instance
resource "aws_security_group" "db_sg" {
  name   = "${var.app_name}-db-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "db_sg_egress_all" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "db_sg_ingress_from_apprunner_sg" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.apprunner_sg.id
}

resource "aws_security_group_rule" "db_sg_ingress_from_bastion_sg" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = var.db_port
  to_port                  = var.db_port
  source_security_group_id = aws_security_group.bastion_sg.id
}

## SG for Bastion Instance
resource "aws_security_group" "bastion_sg" {
  name   = "${var.app_name}-bastion-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "bastion_sg_egress_all" {
  security_group_id = aws_security_group.bastion_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
