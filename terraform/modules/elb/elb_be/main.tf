resource "aws_lb" "be_elb" {
  name               = "turbo-be"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.load_balancer_sg]
  subnets            = var.load_balancer_subnet_list

  tags = {
    Name = "turbo-be"
  }
}

resource "aws_lb_target_group" "be_tg" {
  name     = "turbo-be"
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
    Name = "turbo-be"
  }
}

resource "aws_lb_listener" "be_lb_listener" {
  load_balancer_arn = aws_lb.be_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.be_tg.arn
  }
}