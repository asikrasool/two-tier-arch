variable "identifier" {
  description = "A unique name for the DB instance."
}
variable "subnet_ids" {
  description = "list of subnet id's to place RDS instance"
}

variable "rds_security_group_id" {
  description = "security group used for RDS instance."
}
variable "allocated_storage" {
  description = "The amount of storage in gibibytes (GiB) to allocate to the DB instance."
}

variable "backup_retention_period" {
  description = "The number of days to retain automated backups."
}

variable "backup_window" {
  description = "The daily time range during which automated backups are created."
}

variable "maintenance_window" {
  description = "The weekly time range during which system maintenance can occur."
}

variable "engine" {
  description = "The name of the database engine to be used for the DB instance."
}

variable "engine_version" {
  description = "The version number of the database engine to be used."
}

variable "instance_class" {
  description = "The compute and memory capacity of the DB instance."
}

variable "multi_az" {
  description = "Specifies if the DB instance is a Multi-AZ deployment."
}

variable "db_name" {
  description = "The name of the database instance."
}

variable "username" {
  description = "The name of master user for the DB instance."
}

variable "password_description" {
    description = "The secret description created for database password."
}

variable "port" {
  description = "The port on which the DB accepts connections."
}

variable "publicly_accessible" {
  description = "Determines if the DB instance can be publicly accessed."
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted."
}

variable "storage_type" {
  description = "Specifies the storage type to be associated with the DB instance."
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed."
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor version upgrades are applied automatically."
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot."
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before deleting the instance."
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled."
}
