resource "aws_lb" "elb" {
  name               = "turbo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_sg]
  subnets            = var.load_balancer_subnet_list

  tags = {
    Name = "turbo"
  }
}

resource "aws_lb_target_group" "ecs_fe" {
  name     = "ecs"
  port     = var.ecs_port
  protocol = "HTTP"
  vpc_id   = var.vpc
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  tags = {
    Name = "turbo"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_fe.arn
  }
}