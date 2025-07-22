module "project_alb" {
  source            = "./modules/alb"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ec2_instance_ids  = module.project_ec2.instance_ids
  tags              = local.tags

  depends_on = [module.project_ec2]
}

resource "aws_security_group_rule" "allow_alb_to_ec2_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = module.project_ec2.ec2_sg
  source_security_group_id = module.project_alb.alb_security_group_id
  description              = "Allow HTTP from ALB"
} 