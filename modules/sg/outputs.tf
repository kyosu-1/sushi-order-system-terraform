output "apprunner_sg" {
  description = "App Runner の ENI 用の SG リソース"
  value       = aws_security_group.apprunner_sg
}

output "db_sg" {
  description = "DB 用の SG リソース"
  value       = aws_security_group.db_sg
}

output "bastion_sg" {
  description = "踏台サーバ用の SG リソース"
  value       = aws_security_group.bastion_sg
}
