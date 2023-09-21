# IAM policy for github actions
resource "aws_iam_policy" "github_actions" {
  name = "${var.app_name}_github_actions"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "GetAuthorizationToken",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ManageRepositoryContents",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        "Resource" : var.ecr_repository_arn
      },
      {
        "Sid" : "AllowAppRunnerServiceUpdateService",
        "Effect" : "Allow",
        "Action" : "apprunner:UpdateService",
        "Resource" : var.apprunner_service_arn
      },
      {
        "Sid" : "AllowAppRunnerServiceDescribe",
        "Effect" : "Allow",
        "Action" : [
          "apprunner:List*",
          "apprunner:Describe*",
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowIAMPassRole",
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : var.apprunner_access_role_arn
      }
    ]
  })
}

data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# IAM role for github actions
resource "aws_iam_role" "github_actions" {
  name = "${var.app_name}_github_actions"

  assume_role_policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.github_actions.arn
  ]
}
