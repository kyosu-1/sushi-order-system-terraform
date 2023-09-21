// リソース名に付与するプレフィックス
variable "app_name" {
  type    = string
}

// VPC CIDR
variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

// パブリックサブネットの定義 (名前, CIDR, AZ)
variable "public_subnets" {
  type = map(map(string))
  default = {
    public_1a = { cidr_block = "172.16.1.0/24", az = "ap-northeast-1a" },
    public_1c = { cidr_block = "172.16.2.0/24", az = "ap-northeast-1c" },
    public_1d = { cidr_block = "172.16.3.0/24", az = "ap-northeast-1d" },
  }
}

// App Runner の VPC Connector で指定するサブネットの定義
variable "apprunner_subnets" {
  type = map(map(string))
  default = {
    apprunner_1a = { cidr_block = "172.16.11.0/24", az = "ap-northeast-1a" },
    apprunner_1c = { cidr_block = "172.16.12.0/24", az = "ap-northeast-1c" },
    apprunner_1d = { cidr_block = "172.16.13.0/24", az = "ap-northeast-1d" },
  }
}

// Aurora Cluster のサブネットグループで指定するサブネットの定義
variable "db_subnets" {
  type = map(map(string))
  default = {
    db_1a = { cidr_block = "172.16.21.0/24", az = "ap-northeast-1a" },
    db_1c = { cidr_block = "172.16.22.0/24", az = "ap-northeast-1c" },
    db_1d = { cidr_block = "172.16.23.0/24", az = "ap-northeast-1d" },
  }
}

// NATGW のインターネット側のサブネット名
variable "natgw_subnet_name" {
  type    = string
  default = "public_1a"
}

// 踏台サーバを起動するサブネット名
variable "bastion_subnet_name" {
  type    = string
  default = "public_1a"
}