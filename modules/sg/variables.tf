// リソース名に付与するプレフィックス
variable "app_name" {
  type = string
}

// SG を作成する VPC ID
variable "vpc_id" {
  type = string
}

// RDS 接続用のポート番号
variable "db_port" {
  type = string
}
