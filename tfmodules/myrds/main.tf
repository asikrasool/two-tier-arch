resource "aws_db_subnet_group" "_" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "_" {
  identifier              = var.identifier
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  db_subnet_group_name    = aws_db_subnet_group._.id
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  multi_az                = var.multi_az
  db_name                 = var.db_name
  username                = var.username
  password                = random_password.db_root_pass.result
  port                    = var.port
  publicly_accessible     = var.publicly_accessible
  storage_encrypted       = var.storage_encrypted
  storage_type            = var.storage_type

  vpc_security_group_ids  = [var.rds_security_group_id]

  allow_major_version_upgrade  = var.allow_major_version_upgrade
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade

  final_snapshot_identifier    = var.final_snapshot_identifier
  snapshot_identifier          = var.snapshot_identifier
  skip_final_snapshot          = var.skip_final_snapshot

  performance_insights_enabled = var.performance_insights_enabled
  depends_on                   = [random_password.db_root_pass]
}
