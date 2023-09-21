locals {
  app_name       = "sushi-order-system"
}

// DB
locals {
  db_port        = "3306"
  db_name        = "sushi"
  db_username    = "sushi"
  db_password    = "tmp-password" # 一時的なパスワード(後で変更)
}

// 踏台サーバ
locals {
  bastion_ami_id = "ami-078296f82eb463377" # 踏台サーバ用の AMI ID
}

// AppRunner
locals {
  app_container_port = 8080 // アプリケーションコンテナのポート番号
}
