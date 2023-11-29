resource "aws_ecr_repository" "conduit_be" {
  name = var.be_image_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "conduit_fe" {
  name = var.fe_image_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "conduit_be" {
  repository = aws_ecr_repository.conduit_be.id

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:GetAuthorizationToken"
        ]
      }
    ]
  }
  EOF
}

resource "aws_ecr_repository_policy" "conduit_fe" {
  repository = aws_ecr_repository.conduit_fe.id

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:GetAuthorizationToken"
        ]
      }
    ]
  }
  EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_policy_be" {
  repository = aws_ecr_repository.conduit_be.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_policy_fe" {
  repository = aws_ecr_repository.conduit_fe.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}