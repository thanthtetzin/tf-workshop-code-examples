## 1. Deploying S3 bucket and static site hosting
- open `main.tf` and replace `your_name` with your actual name
- run `cd gh-action-hands-on` in terminal
- copy paste aws playgroud access keys in terminal
- run `terraform init`
- run `terraform plan`
- run `terraform apply -auto-approve`
- will get strange 403 error of aws_s3_bucket_policy (probably playground account is setup with specific permission? 🤔)
- run `terraform apply -auto-approve` again
- Go to AWS Playground > Type 'S3' in searchbar > filter by `gha-{your_name}`
- confirm new S3 bucket with your name exists in AWS
- confirm that static site hosting is enabled, public access is turned on and bucket policy is attached

### 2. Destroy all the resources we deployed
- run `terraform destroy -auto-approve`