
#VPC Block 

module "vpc" {
  source               = "../modules/vpc"
  cidr_block           = var.cidr_block
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  private_subnets_cidr_2 = var.private_subnets_cidr_2
  region               = var.region
  avaliablity_zone     = var.avaliablity_zone
  avaliablity_zone_2 = var.avaliablity_zone_2
}


#EC2 Webserve 

module "mywebserver" {
  source            = "../modules/ec2"
  key               = file("${path.module}/id_rsa.pub")
  instance_type     = var.instance_type
  key_name          = var.key_name
  port              = var.port
  image_name        = var.image_name # Date source block of AMI

  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.security_group_id
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id

}
  

module "rds" {
  source                  = "../modules/rds"
  my-db-subnet-group = var.my-db-subnet-group
  subnet_ids = var.subnet_ids 
  cluster_identifier = var.cluster_identifier
  engine = var.engine
  engine_version = var.engine_version
  database_name = var.database_name
  master_username = var.master_username
  master_password = var.master_password
  backup_retention_period = var.backup_retention_period
  instance_class = var.instance_class
  engine_instance = var.engine_instance
  identifier = var.identifier
}