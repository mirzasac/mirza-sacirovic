#CodeBuild Projects
#IAM Role for AWS CodeBuild Project
resource "aws_iam_role" "mirzasa-codebuild-role" {
  name = "code-build-mirzasa-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = {
    Name = "code-build-mirzasa-service-role"
  }
}
#Inline Policy for AWS CodeBuild Project IAM Role
resource "aws_iam_role_policy" "mirzasa-codebuild-role-policy" {
  name = "code-build-mirzasa-policy"
  role = "${aws_iam_role.mirzasa-codebuild-role.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::mirzasa-codepipeline-dev",
        "arn:aws:s3:::mirzasa-codepipeline-dev/*"
      ]
    }
  ]
}
POLICY
}
#CodeBuild Project Role Policy Attachments
resource "aws_iam_role_policy_attachment" "amazon-ecr-full-access" {
  role = "${aws_iam_role.mirzasa-codebuild-role.name}"
  policy_arn = "${data.aws_iam_policy.ecr-full-access.arn}"
}
resource "aws_iam_role_policy_attachment" "amazon-ecs-full-access" {
  role = "${aws_iam_role.mirzasa-codebuild-role.name}"
  policy_arn = "${data.aws_iam_policy.ecs-full-access.arn}"
}
#AWS CodeBuildProjects
resource "aws_codebuild_project" "mirzasa-codebuild-project" {
  name = "mirzasa-codebuild"
  build_timeout = 20
  service_role = "${aws_iam_role.mirzasa-codebuild-role.arn}"
  environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "aws/codebuild/standard:2.0"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode = true
      environment_variable {
        name = "env"
        value = "dev"
      }
      environment_variable {
        name = "aws_default_region"
        value = "${var.region}"
      }
  }
  source {
      type = "CODEPIPELINE"
      buildspec = "mirzasa-cicd/buildspec.yml"
  }
  artifacts {
      type = "CODEPIPELINE"
  }
  tags = {
    Name = "mirzasa-codebuild"
  }
}