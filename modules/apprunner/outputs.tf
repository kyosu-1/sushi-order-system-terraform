output "service" {
  description = "Apprunner Service リソース"
  value       = aws_apprunner_service.service
}

output "service_name" {
  description = "Apprunner Service 名"
  value       = var.app_name
}

output "vpc_connector" {
  description = "Apprunner VPC Connector リソース"
  value       = aws_apprunner_vpc_connector.connector
}

output "access_role" {
  description = "App Runner が ECR にアクセスするための IAM ロールリソース"
  value       = aws_iam_role.apprunner_access_role
}

output "instance-role" {
  description = "App Runner のインスタンスロール"
  value       = aws_iam_role.apprunner_service_role
}

output "instance-role-policy" {
  description = "App Runner のインスタンスロールのポリシー"
  value       = aws_iam_policy.apprunner_service_role_policy
}

output "custom_domain_association" {
  description = "App Runner カスタムドメイン名のアソシエーションリソース"
  value       = aws_apprunner_custom_domain_association.app
}

output "custom_domain_name" {
  description = "App Runner カスタムドメイン名用の Route 53 レコードリソース"
  value       = aws_route53_record.record
}

output "custom_domain_certificate_records" {
  description = "App Runner カスタムドメインの証明書検証用の Route 53 レコードリソース"
  value       = aws_route53_record.certificate_records
}