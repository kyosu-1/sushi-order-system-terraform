module "sushi_order_system_api_ecr" {
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

module "bastion" {
  source = "../modules/bastion"

  app_name = local.app_name

  bastion_ami_id    = local.bastion_ami_id
  bastion_sg_id     = module.sg.bastion_sg.id
  bastion_subnet_id = module.vpc.bastion_subnet.id
}

module "db" {
  source = "../modules/rds"

  app_name    = local.app_name
  db_name     = local.db_name
  db_port     = local.db_port
  db_username = local.db_username
  db_password = local.db_password

  db_sg_id      = module.sg.db_sg.id
  db_subnet_ids = [for k, subnet in module.vpc.db_subnets : subnet.id]
}