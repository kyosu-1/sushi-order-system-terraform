// リソース名に付与するプレフィックス
variable "app_name" {
  type = string
}

// App Runner サービスの runtime_environment_variables に渡す環境変数
variable "env" {
  type = map(string)
  default = {
    DB_USER     = ""
    DB_PASSWORD = ""
    DB_PORT     = ""
    DB_HOST     = ""
    DB_DATABASE = ""
  }
}

// App Runner で起動するコンテナで listen するポート番号
variable "app_container_port" {
  type = string
}

// App Runner が使用する ECR リポジトリの URL
variable "ecr_repository_url" {
  type = string
}

// App Runner 用のサブネット の ID のリスト 
variable "subnet_ids" {
  type = list(string)
}

// App Runner 用の SG の ID
variable "apprunner_sg_id" {
  type = string
}

// App Runenr カスタムドメイン名として使用する FQDN
variable "custom_domain_name" {
  type = string
}

// App Runner カスタムドメイン名用のレコードを作成する Route 53 パブリックホストゾーンの ID
variable "hosted_zone_id" {
  type = string
}
