## ECR Repository
output "repo" {
  description = "ECR repository リソース"
  value       = aws_ecr_repository.repo
}