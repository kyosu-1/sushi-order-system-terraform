## App Runner Service
resource "aws_apprunner_service" "service" {
  service_name = var.app_name

  source_configuration {
    image_repository {
      image_configuration {
        port = var.app_container_port
        runtime_environment_variables = {
          DB_USER     = var.env.DB_USER
          DB_PASSWORD = var.env.DB_PASSWORD
          DB_PORT     = var.env.DB_PORT
          DB_HOST     = var.env.DB_HOST
          DB_DATABASE = var.env.DB_DATABASE
        }
      }

      image_identifier      = "${var.ecr_repository_url}:latest"
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_access_role.arn
    }
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_service_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }

  lifecycle {
    ignore_changes = [source_configuration[0].image_repository[0].image_identifier]
  }

  depends_on = [aws_iam_role.apprunner_access_role, aws_iam_role.apprunner_service_role]
}

## App Runner Service VPC Connector
resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.app_name}-vpc-connector"
  subnets            = var.subnet_ids
  security_groups    = [var.apprunner_sg_id]

  lifecycle {
    ignore_changes = [tags_all]
  }
}

## App Runner Access Role For ECR
resource "aws_iam_role" "apprunner_access_role" {
  name = "${var.app_name}-apprunner-access-role-for-ECR"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
  ]
}

## App Runner Instance Role
resource "aws_iam_role" "apprunner_service_role" {
  name = "${var.app_name}-apprunner-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    aws_iam_policy.apprunner_service_role_policy.arn
  ]
}

## App Runner Instance Role Policy
## 最小特権の原則的にはResourceをARN単位で指定した方が良いかも
resource "aws_iam_policy" "apprunner_service_role_policy" {
  name = "${var.app_name}-apprunner-service-role-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "AllowAccessLambdaFunction",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:InvokeFunctionUrl"
        ],
        "Resource" : "*",
      },
    ]
  })
}

## App Runner Custom Domain Name
resource "aws_apprunner_custom_domain_association" "app" {
  domain_name          = var.custom_domain_name
  service_arn          = aws_apprunner_service.service.arn
  enable_www_subdomain = false
}

### Alias record for App Runner custom domain
resource "aws_route53_record" "record" {
  zone_id = var.hosted_zone_id
  name    = aws_apprunner_custom_domain_association.app.domain_name
  type    = "A"
  alias {
    name    = aws_apprunner_custom_domain_association.app.dns_target
    zone_id = "Z08491812XW6IPYLR6CCA" # from https://docs.aws.amazon.com/general/latest/gr/apprunner.html

    evaluate_target_health = true
  }
}

### CNAME records for App Runner custom domain verification
## NOTE: This implementation is due to hashicorp/terraform-provider-aws issue 23460.
## `certificate_validation_records` cannot be iterated.
##
resource "aws_route53_record" "certificate_records" {
  count = 2

  zone_id = var.hosted_zone_id
  name    = tolist(aws_apprunner_custom_domain_association.app.certificate_validation_records)[count.index].name
  type    = tolist(aws_apprunner_custom_domain_association.app.certificate_validation_records)[count.index].type
  records = [
    tolist(aws_apprunner_custom_domain_association.app.certificate_validation_records)[count.index].value
  ]
  allow_overwrite = true
  ttl             = 60
}