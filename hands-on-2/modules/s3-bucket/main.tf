locals {
  owner   = var.owner
  purpose = var.purpose

  common_tags = {
    Owner   = local.owner
    Purpose = local.purpose
  }
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "tf-workshop-${lower(local.owner)}-${lower(var.name)}-${random_string.random.result}"
  force_destroy = true
  tags = local.common_tags
}
