// リソース名に付与するプレフィックス
variable "app_name" {
  type = string
}

// データベース名
variable "db_name" {
  type = string
}

// DB 接続用ポート番号
variable "db_port" {
  type = string
}

// DB ユーザ名
variable "db_username" {
  type = string
}

// DB パスワード(temporary)
variable "db_password" {
  type = string
}

// DB 用の SG の ID
variable "db_sg_id" {
  type = string
}

// DB 用のサブネットグループで指定するサブネットの ID のリスト
variable "db_subnet_ids" {
  type = list(string)
}
