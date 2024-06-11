locals {
  owner   = "your_name"
  purpose = "web-infrastructure-workshops"

  common_tags = {
    Owner   = local.owner
    Purpose = local.purpose
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "gha-${lower(local.owner)}-custom-action-hosting"
  force_destroy = true
  tags = local.common_tags
}

# unblocking all public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# setting up static site hosting
resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
}

# attaching bucket policy to allow public read-only permission
resource "aws_s3_bucket_policy" "allow_public_read_access_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.allow_public_read_access_policy_doc.json
}

data "aws_iam_policy_document" "allow_public_read_access_policy_doc" {
  statement {
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}
