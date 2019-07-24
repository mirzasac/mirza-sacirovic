#S3 Bucket for AWS CodePipeline
resource "aws_s3_bucket" "mirzasa-codepipeline" {
  bucket = "mirzasa-codepipeline-${var.env}"
  acl = "private"
  force_destroy = true
  tags = {
      Name = "mirzasa-codepipeline-${var.env}"
  }
}
#IAM Service Role for AWS CodePipeline
resource "aws_iam_role" "codepipeline-service-role" {
  name = "mirzasa-codepipeline-service-role-${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
#IAM Policy for Service Role for AWS CodePipeline
resource "aws_iam_role_policy" "codepipeline-service-role-policy" {
  name = "mirzasa-codepipeline-role-policy"
  role = "${aws_iam_role.codepipeline-service-role.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.mirzasa-codepipeline.arn}",
        "${aws_s3_bucket.mirzasa-codepipeline.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
#CodePipelines
resource "aws_codepipeline" "mirzasa" {
  name = "mirzasa-${var.env}"
  role_arn = "${aws_iam_role.codepipeline-service-role.arn}"
  artifact_store {
      location = "${aws_s3_bucket.mirzasa-codepipeline.bucket}"
      type = "S3"
  }
  stage {
      name = "Source"
      action {
          name = "Source"
          category = "Source"
          owner = "ThirdParty"
          provider = "GitHub"
          version = "1"
          output_artifacts = ["mirzasa-github"]
          configuration = {
              Owner = "mirzasalovanovic"
              Repo = "mistral-iac"
              Branch = "${lookup(var.git-branches, var.env)}"
              OAuthToken = "${data.aws_ssm_parameter.mirzasa-github-token.value}"
              PollForSourceChanges = false
          }
      }
  }
  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["mirzasa-github"]
      version = "1"
      configuration = {
          ProjectName = "${aws_codebuild_project.mirzasa-codebuild-project.name}"
      }
    }
  }
}
resource "aws_codepipeline_webhook" "mirzasa" {
  name = "mirzasa-${var.env}"
  authentication = "GITHUB_HMAC"
  target_action = "Source"
  target_pipeline = "${aws_codepipeline.mirzasa.id}"
  authentication_configuration {
    secret_token = "${data.aws_ssm_parameter.mirzasa-github-token.value}"
  }
  filter {
    json_path = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}
resource "github_repository_webhook" "mirzasa" {
  repository = "${data.github_repository.mirzasa-repo.name}"
  configuration {
    url = "${aws_codepipeline_webhook.mirzasa.url}"
    content_type = "json"
    insecure_ssl = false
    secret = "${data.aws_ssm_parameter.mirzasa-github-token.value}"
  }
  events = [
    "push"
  ]
}