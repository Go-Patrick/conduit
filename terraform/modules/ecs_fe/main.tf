resource "aws_ecs_cluster" "turbo_fe" {
  name = "turbo-fe"
  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "turbo-fe"
  }
}

resource "aws_ecs_task_definition" "dev_to" {
  family = "turbo-fe"
  container_definitions = <<TASK_DEFINITION
  [
  {
    "portMappings": [
      {
        "hostPort": 3000,
        "protocol": "tcp",
        "containerPort": 3000
      }
    ],
    "cpu": 512,
    "environment": [
      {
        "name": "NEXT_PUBLIC_HOST_URL",
        "value": "http://${var.backend_url}"
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

resource "aws_ecs_service" "turbo_fe" {
  name = "turbo-fe"
  cluster = aws_ecs_cluster.turbo_fe.id
  task_definition = aws_ecs_task_definition.dev_to.arn
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets = [var.ecs_subnet_a.id, var.ecs_subnet_b.id]
    security_groups = [var.ecs_sg.id, var.ecr_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ecs_target_group.arn
    container_name = "turbo-fe"
    container_port = 3000
  }

  service_registries {
    registry_arn = aws_service_discovery_service.turbo_fe.arn
  }
}

resource "aws_service_discovery_service" "turbo_fe" {
  name = "frontend"

  dns_config {
    namespace_id = var.service_namespace

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_appautoscaling_target" "dev_to_target" {
  max_capacity = 2
  min_capacity = 1
  resource_id = "service/${aws_ecs_cluster.turbo_fe.name}/${aws_ecs_service.turbo_fe.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_memory" {
  name               = "dev-to-memory-fe"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

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
  resource_id = aws_appautoscaling_target.dev_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
  service_namespace = aws_appautoscaling_target.dev_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}