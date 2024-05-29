# Deploying s3 bucket via child local module and attach bucket policy

## ToDos

### 1. Calling child local module by passing input arguments to create s3 bucket
- run `cd hands-on-2`
- copy paste aws playgroud access keys in terminal
- copy and paste the following code into root `main.tf`
module "s3_test_bucket" {
  source = "./modules/s3-bucket"
}

- 🚨 you will see terraform error about `name` and `owner` and `region` inputs are required
- pass them correctly (replace `your_name` with your actual name)

module "s3_test_bucket" {
  source = "./modules/s3-bucket"
  name = "test-bucket"
  owner = "your_name"
  region = "eu-west-1"
}

- run `terraform init`
- run `terraform plan`
- 🚨 you will see region input throws an error
- fix to pass the valid region value
module "s3_test_bucket" {
  region = "eu-central-1"
}

- run `terraform plan`
- run `terraform apply -auto-approve` enter "yes" to deploy


### 2. Attaching Deny policy to s3 bucket created by module
- copy paste the following to the `main.tf`
resource "aws_s3_bucket_policy" "allow_public_read_access_policy" {
  bucket = module.s3_test_bucket.bucket_id
  policy = data.aws_iam_policy_document.allow_public_read_access_policy_doc.json
}

data "aws_iam_policy_document" "allow_public_read_access_policy_doc" {
  statement {
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    effect = "Deny"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      module.s3_test_bucket.bucket_arn,
      "${module.s3_test_bucket.bucket_arn}/*",
    ]
  }
}

- run `terraform plan`
- run `terraform apply -auto-approve` enter "yes" to deploy
- Go to AWS Playground > Type 'S3' in searchbar > filter by your name
- confirm new S3 bucket with your name exists and also bucket policy in permission tab in AWS

### 3. Destroy all the resources we deployed
- run `terraform destroy` enter value "yes"