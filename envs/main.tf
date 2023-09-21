module "sushi-order-system-api-ecr" {
    source = "../modules/ecr"
    
    app_name       = local.app_name
}

module "vpc" {
  source = "../modules/vpc"

  app_name = local.app_name

  vpc_cidr = "172.16.0.0/16"
  public_subnets = {
    public_1a = { cidr_block = "172.16.1.0/24", az = "ap-northeast-1a" },
    public_1c = { cidr_block = "172.16.2.0/24", az = "ap-northeast-1c" },
    public_1d = { cidr_block = "172.16.3.0/24", az = "ap-northeast-1d" },
  }
  apprunner_subnets = {
    apprunner_1a = { cidr_block = "172.16.11.0/24", az = "ap-northeast-1a" },
    apprunner_1c = { cidr_block = "172.16.12.0/24", az = "ap-northeast-1c" },
    apprunner_1d = { cidr_block = "172.16.13.0/24", az = "ap-northeast-1d" },
  }
  db_subnets = {
    db_1a = { cidr_block = "172.16.21.0/24", az = "ap-northeast-1a" },
    db_1c = { cidr_block = "172.16.22.0/24", az = "ap-northeast-1c" },
    db_1d = { cidr_block = "172.16.23.0/24", az = "ap-northeast-1d" },
  }
  natgw_subnet_name   = "public_1a"
  bastion_subnet_name = "public_1a"
}

module "sg" {
  source = "../modules/sg"

  app_name = local.app_name

  db_port    = local.db_port
  vpc_id     = module.vpc.vpc.id
}
