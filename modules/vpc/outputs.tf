## VPC
output "vpc" {
  description = "VPC リソース"
  value       = aws_vpc.vpc
}

## Subnets
output "public_subnets" {
  description = "パブリックサブネットリソースのリスト"
  value       = aws_subnet.public
}

output "apprunner_subnets" {
  description = "App Runner の VPC コネクタで指定するサブネットリソースのリスト"
  value       = aws_subnet.apprunner
}

output "db_subnets" {
  description = "Aurora Cluster のサブネットグループに指定するサブネットリソースのリスト"
  value       = aws_subnet.db
}

## bastion subnet
output "bastion_subnet" {
  description = "踏台サーバを起動するサブネットリソース"
  value       = aws_subnet.public[var.bastion_subnet_name]
}

## IGW
output "igw_id" {
  description = "IGW の ID"
  value       = aws_internet_gateway.igw.id
}

## Route Tables
output "public_rt" {
  description = "パブリックサブネットのルートテーブル"
  value       = aws_route_table.public
}

output "apprunner_rt" {
  description = "App Runner 用サブネットのルートテーブル (Private)"
  value       = aws_route_table.private_apprunner
}

output "db_rt" {
  description = "Aurora Cluster 用サブネットのルートテーブル (Local)"
  value       = aws_route_table.private_db
}