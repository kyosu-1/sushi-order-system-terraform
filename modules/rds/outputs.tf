output "db_instance" {
  description = "RDS for MySQL instance リソース"
  value       = aws_db_instance.mysql_instance
}

output "subnet_group" {
  description = "RDS for MySQL 用のサブネットグループリソース"
  value       = aws_db_subnet_group.db_subnet_group
}

output "db_host" {
  description = "RDS for MySQL のホスト名"
  value       = aws_db_instance.mysql_instance.address
}
