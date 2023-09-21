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