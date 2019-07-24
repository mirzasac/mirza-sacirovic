#Security Group
resource "aws_security_group" "mirzasa-ecs-task" {
  name = "mirzasa-ecs-task-${var.env}"
  description = "mirzasa ECS Task ${var.env} Environment"
  vpc_id = "${aws_vpc.mirzasa-vpc.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${aws_security_group.mirzasa-alb-security-group.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "mirzasa-ecs-task-${var.env}"
  }
}
#ecsTaskExecutionRole
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole-${var.env}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole" {
  role = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "${data.aws_iam_policy.ecs-task-execution-policy.arn}"
}
#CloudWatch Log Group
resource "aws_cloudwatch_log_group" "mirzasa-log-group" {
  name = "/ecs/mirzasa-log-group-${var.env}"
}
#ECS Task Definition
resource "aws_ecs_task_definition" "mirzasa-task-definition" {
  family = "mirzasa-task-definition-${var.env}"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
  memory = 512
  cpu = 256
  container_definitions = <<DEFINITION
[
    {
        "name": "nginx",
        "image": "802248536421.dkr.ecr.us-east-2.amazonaws.com/mirzasa-ecr-dev:nginx",
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": 80
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/mirzasa-ecr-dev",
                "awslogs-region": "us-east-2",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]
DEFINITION
}
#ECS Service
resource "aws_ecs_service" "mirzasa-service" {
  launch_type = "FARGATE"
  task_definition = "${aws_ecs_task_definition.mirzasa-task-definition.arn}"
  cluster = "${aws_ecs_cluster.ecs.arn}"
  name = "mirzasa-${var.env}"
  desired_count = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200
  network_configuration {
      subnets = [
        "${aws_subnet.public-subnet-1.id}",
        "${aws_subnet.public-subnet-2.id}"
      ]
      security_groups = [
        "${aws_security_group.mirzasa-alb-security-group.id}"
      ]
      assign_public_ip = true
  }
  load_balancer {
      target_group_arn = "${aws_lb_target_group.mirzasa-target-group.arn}"
      container_name = "nginx"
      container_port = "80"
  }
  health_check_grace_period_seconds = 0
}