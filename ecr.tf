#ECR
resource "aws_ecr_repository" "ecr" {
  name = "mirzasa-ecr-${var.env}"
  tags = {
      Name = "mirzasa-ecr-${var.env}"
  }
}
#ECR Policy
resource "aws_ecr_lifecycle_policy" "ecr-policy" {
  repository = "${aws_ecr_repository.ecr.name}"
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${lookup(var.ecr-number-of-images, var.env)} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${lookup(var.ecr-number-of-images, var.env)}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
