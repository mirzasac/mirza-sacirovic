#IAM Policies
data "aws_iam_policy" "s3-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
data "aws_iam_policy" "ecr-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
data "aws_iam_policy" "ecs-full-access" {
  arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
data "aws_iam_policy" "ecs-task-execution-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
#GitHub Repositories
data "github_repository" "mirzasa-repo" {
  full_name = "mirzasac/mirza-sacirovic"
}
#Parameter Store
data "aws_ssm_parameter" "mirzasa-github-token" {
  name = "mirzasa-github-token"
}