module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  public_subnets  = ["10.0.1.0/24"]
  private_subnets = []

  enable_dns_support   = true
  enable_dns_hostnames = true

  public_dedicated_network_acl = true
  public_inbound_acl_rules = [
    {
      rule_number = 800
      rule_action = "allow"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 801
      rule_action = "allow"
      from_port   = 32768
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 9231
      to_port     = 9231
      protocol    = "udp"
      cidr_block  = "0.0.0.0/0"
    },
    {
      rule_number = 101
      rule_action = "allow"
      from_port   = 9232
      to_port     = 9232
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
    }
  ]
  public_outbound_acl_rules = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_block  = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform = "true"
    Stack     = var.name
  }
}

module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9231
      to_port     = 9231
      protocol    = "udp"
      description = "ACC UDP port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9232
      to_port     = 9232
      protocol    = "tcp"
      description = "ACC TCP port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Terraform = "true"
    Stack     = var.name
  }
}
