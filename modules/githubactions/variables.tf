// リソース名に付与するプレフィックス
variable "app_name" {
  type = string
}

// Assume Role を許可する Github リポジトリ
variable "github_repo" {
  type = string
}

// Github Actions からのアクセスを許可する ECR リポジトリの ARN
variable "ecr_repository_arn" {
  type = string
}

// Github Actions からのアクセスを許可する App Runner サービスの ARN
variable "apprunner_service_arn" {
  type = string
}

// 対象の App Runner サービスが使用する IAM ロールの ARN
variable "apprunner_access_role_arn" {
  type = string
}