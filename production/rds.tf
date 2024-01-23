module "my_rds" {
  source = "../tfmodules/myrds"

  publicly_accessible   = false
  multi_az              = false
  subnet_ids            = module.vpc.private_subnet_ids
  rds_security_group_id = aws_security_group.rds_sg1.id
  db_name               = "cloudbees" # use empty string to start without a database created
  username              = "admin"     # rds_password is generated
  #   password               = random_password.db_root_pass.result
  password_description = "Password will be created and stored in AWS Secret manager."
  port                 = 3306

  identifier     = "mysql"
  engine         = "mysql"
  engine_version = "5.7"

  instance_class    = "db.t2.micro"
  storage_type      = "gp2"
  allocated_storage = 10
  storage_encrypted = false

  auto_minor_version_upgrade   = false
  allow_major_version_upgrade  = false
  maintenance_window           = "Mon:00:00-Mon:03:00"
  backup_window                = "10:46-11:16"
  backup_retention_period      = 1
  final_snapshot_identifier    = "prod-website-db-snapshot"
  snapshot_identifier          = null # used to recover from a snapshot
  skip_final_snapshot          = true
  performance_insights_enabled = false
}

