resource "aws_ecs_cluster" "fe_ecs_cluster" {
  name = "turbo-fe"
  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "turbo-fe"
  }
}

resource "aws_ecs_task_definition" "fe_ecs_task_def" {
  family = "turbo-fe"
  container_definitions = <<TASK_DEFINITION
  [
  {
    "portMappings": [
      {
        "hostPort": ${var.container_port},
        "protocol": "tcp",
        "containerPort": ${var.container_port}
      }
    ],
    "cpu": 512,
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "production"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/turbo-fe",
        "awslogs-region": "ap-southeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "memory": 1024,
    "image": "${var.image_name}",
    "essential": true,
    "name": "turbo-fe"
  }
]
TASK_DEFINITION

  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory = "1024"
  cpu = "512"
  execution_role_arn = var.ecs_role_name
  task_role_arn = var.ecs_role_name

  tags = {
    Name = "turbo-fe"
  }
}

resource "aws_ecs_service" "fe_ecs_service" {
  name = "turbo-fe"
  cluster = aws_ecs_cluster.fe_ecs_cluster.id
  task_definition = aws_ecs_task_definition.fe_ecs_task_def.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets = var.ecs_subnet_list
    security_groups = [var.ecs_sg]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ecs_target_group
    container_name = "turbo-fe"
    container_port = var.container_port
  }
}

resource "aws_appautoscaling_target" "fe_asl_target" {
  max_capacity = 2
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.fe_ecs_cluster.name}/${aws_ecs_service.fe_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_memory" {
  name               = "dev-to-memory-fe"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.fe_asl_target.resource_id
  scalable_dimension = aws_appautoscaling_target.fe_asl_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.fe_asl_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_appautoscaling_policy" "dev_to_cpu" {
  name = "dev-to-cpu-fe"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.fe_asl_target.resource_id
  scalable_dimension = aws_appautoscaling_target.fe_asl_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.fe_asl_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}