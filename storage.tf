resource "random_uuid" "bucket_id" {}

resource "aws_s3_bucket" "install_storage" {
  bucket = "${var.name}-${random_uuid.bucket_id.result}"
  acl    = "public-read"

  versioning {
    enabled = false
  }

  tags = {
    Name      = var.name
    Terraform = "true"
    Stack     = var.name
  }
}

resource "aws_s3_bucket_object" "install_file" {
  key    = "${var.name}-install.zip"
  bucket = aws_s3_bucket.install_storage.id
  source = var.acc_server_zip_file
  acl    = "public-read"
}
