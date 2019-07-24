#ECS Cluster
resource "aws_ecs_cluster" "ecs" {
  name = "mirzasa-ecs-${var.env}"
  tags = {
      Name = "mirzasa-ecs-${var.env}"
  }
}