module acme_setup {
  source = "github.com/aparnagk76/terraform-aws-infrasetup.git?ref=v0.0.1"

  backend_instance_count = var.backend_instance_count
  egress_cidr_blocks     = var.egress_cidr_blocks
  environment_name       = var.environment_name
  ingress_cidr_blocks    = var.ingress_cidr_blocks
  instance_type          = var.instance_type
  vpc_cidr_block         = var.vpc_cidr_block
}
