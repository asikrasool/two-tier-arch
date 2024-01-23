resource "aws_security_group" "ec2_sg1" {
  name   = "ec2-sg1"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "alb_sg1" {
  name   = "alb-sg1"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "rds_sg1" {
  # Allow incoming MySQL traffic only from the EC2 instances
  name   = "rds-sg1"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg1.id
  source_security_group_id = aws_security_group.alb_sg1.id
}

resource "aws_security_group_rule" "ingress_ec2_health_check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg1.id
  source_security_group_id = aws_security_group.alb_sg1.id
}

resource "aws_security_group_rule" "full_egress_ec2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ec2_sg1.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_sg1.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_traffic" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg1.id
  source_security_group_id = aws_security_group.ec2_sg1.id
}

resource "aws_security_group_rule" "egress_alb_health_check" {
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg1.id
  source_security_group_id = aws_security_group.ec2_sg1.id
}

resource "aws_security_group_rule" "ingress_rds_traffic" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg1.id
  source_security_group_id = aws_security_group.ec2_sg1.id
}