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

resource "aws_ecr_repository" "permission_service_ecr_repo" {
  name                 = "tf-workshop-${lower(local.owner)}-permission_service_ecr_repo_${random_string.random.result}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.common_tags
}

resource "aws_ecr_lifecycle_policy" "ps_lifecycle_policy" {
  repository = aws_ecr_repository.permission_service_ecr_repo.name
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

