module "sushi-order-system-api-ecr" {
    source = "../modules/ecr"
    
    app_name       = local.app_name
}
