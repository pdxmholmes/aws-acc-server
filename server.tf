locals {
  install_file_url  = "https://${aws_s3_bucket.install_storage.id}.s3-${var.region}.amazonaws.com/acc-server-install.zip"
  init_file = file("${path.module}/init.d.sh")
}

data "aws_ami" "debian10" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-10-amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["136693071363"]
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.debian10.id
  monitoring    = false
  instance_type = var.instance_type
  key_name      = var.admin_key_pair_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [module.sg.this_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]

  user_data_base64 = base64encode(replace(local.init_file, "%INSTALL_URL", local.install_file_url)))

  tags = {
    Name      = var.name
    Terraform = "true"
    Stack     = var.name
  }
}
