output "bastion_instance" {
  description = "踏台サーバの EC2 インスタンスリソース"
  value       = aws_instance.bastion
}

output "bastion_instance_role" {
  description = "踏台サーバが使用する IAM ロールリソース"
  value       = aws_iam_role.bastion_role
}

output "bastion_instance_profile" {
  description = "踏台サーバの IAM インスタンスプロファイルリソース"
  value       = aws_iam_instance_profile.bastion_profile
}