# Deploying static site hosting in S3

## ToDos

### 1. Deploying new AWS S3 bucket
- run `cd hands-on-3`
- copy paste aws playgroud access keys in terminal
- open `provider.tf` and copy paste the following provider code:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "eu-central-1"
}
```

- open `main.tf` and copy paste the following and replace `your_name` with your actual name:
```
locals {
  owner   = "your_name"
  purpose = "BO platform Terraform Basic Features Workshop"

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
  bucket        = "tf-workshop-${lower(local.owner)}-${random_string.random.result}"
  force_destroy = true
  tags = local.common_tags
}
```

- run `terraform init`
- run `terraform fmt` to make codes prettier
- run `terraform plan`
- run `terraform apply` enter "yes" to deploy
- Go to AWS Playground > Type 'S3' in searchbar > filter by your name
- confirm new S3 bucket with your name exists in AWS

### 2. Uploading html files to existing S3 bucket (Automating with GH action in real world usecase)
- Copy paste this code to `main.tf`
```
resource "aws_s3_object" "upload_object" {
  for_each     = fileset("s3_files/", "*")
  bucket       = aws_s3_bucket.bucket.id
  key          = each.value
  source       = "s3_files/${each.value}"
  etag         = filemd5("s3_files/${each.value}")
  content_type = "text/html"
}
```

- run `terraform plan`
- run `terraform apply -auto-approve`
- open your S3 bucket and click Objects tab and see index.html and error.html are uploaded.

### 3. Setting up static site hosting in S3 bucket
- copy paste the following code to `main.tf`
```
resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}
```

- run `terraform plan`
- run `terraform apply -auto-approve`
- open your S3 bucket and click Properties tab and see "Static website hosting" section. And click the website url
- 🚨 you will see 403 Forbidden error
- check S3 Bucket > Permission tab > Block public access > you will see it blocks all public access > So we need to unblock it


### 4. Unblocking all public access
- copy paste the following to `main.tf`
```
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```
- run `terraform plan`
- run `terraform apply -auto-approve`
- refresh your S3 bucket Permisson tab and you will see `Off` in Block public access
- Now try to refresh your s3 website url
- 🚨 Still 403 forbidden?? 🚨


### 5. Attaching bucket policy to allow public read-only permission
- copy paste the following code to `main.tf`
```
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
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}
```

- run `terraform plan`
- run `terraform apply -auto-approve`
- Now try to refresh your s3 website url
- You should see the home page now 🎉


### 6. Destroy all the resources we deployed
- run `terraform destroy` enter value "yes"
