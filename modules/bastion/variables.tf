// リソース名に付与するプレフィックス
variable "app_name" {
  type = string
}

// 踏台サーバで使用する Amazon Linux 2 の AMI ID
variable "bastion_ami_id" {
  type = string
}

// 踏台サーバ用の SG の ID
variable "bastion_sg_id" {
  type = string
}

// 踏台サーバを起動するサブネットの ID
variable "bastion_subnet_id" {
  type = string
}
