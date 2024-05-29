## Deploying new AWS ECR Repository and attach lifecycle policy

### 1. Deploying new AWS ECR Repository Resource
- run `cd hands-on-1`
- copy paste aws playgroud access keys in terminal
- open `main.tf` and add your name in `locals.owner` for reference and save the file
- run `terraform init`
- run `terraform plan`
- run `terraform apply` enter "yes" to deploy
- check terraform.tfstate file to see the mapping json to realworld resources
- can also run `terraform state list` to see the deployed resources
- login to AWS Playground > Type 'ECR' in searchbar > filter by your name
- confirm new ECR Repo with your name exists in AWS

### 2. Create New Lifecycle Policy and Attach it to ECR Repository
- Copy paste the following tf code to `main.tf`

```
resource "aws_ecr_lifecycle_policy" "ps_lifecycle_policy" {
  repository              = aws_ecr_repository.permission_service_ecr_repo.name
        policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
```

- notice that formatting is a bit off
- run `terraform fmt` to make it prettier
- run `terraform plan`
- run `terraform apply` enter "yes" to deploy
- Go to AWS Playground > Type 'ECR' in searchbar > filter by your name
- click on your ECR repo > select `Lifecycle Policy` on left side menu
- confirm new lifecycle policy is existed

### 3. Destroy the cloud resources we deployed
- run `terraform destroy` enter value "yes"
