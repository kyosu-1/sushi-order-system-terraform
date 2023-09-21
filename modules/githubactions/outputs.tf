output "iam_policy" {
  description = "Github Actions に付与する IAM ポリシーリソース"
  value       = aws_iam_policy.github_actions
}

output "iam_role" {
  description = "Github Actions が使用する IAM ロールリソース"
  value       = aws_iam_role.github_actions
}
