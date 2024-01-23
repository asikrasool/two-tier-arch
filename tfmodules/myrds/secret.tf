resource "random_password" "db_root_pass" {
  length = 16
  special = true
  min_special = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_secret" {
  description = var.password_description
  name        = "${var.db_name}-secret"
  recovery_window_in_days = "0"
}

resource "aws_secretsmanager_secret_version" "secret" {
  lifecycle {
    ignore_changes = [
      "secret_string"
    ]
  }
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = <<EOF
{
  "username": "${var.username}",
  "engine": "${var.engine}",
  "dbname": "${var.db_name}",
  "host": "${aws_db_instance._.address}",
  "password": "${random_password.db_root_pass.result}",
  "port": "${aws_db_instance._.port}",
}
EOF
}