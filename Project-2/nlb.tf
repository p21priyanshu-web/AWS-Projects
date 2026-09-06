resource "aws_lb" "nlb" {
  name               = "${var.project_name}-nlb"
  internal           = false
  load_balancer_type = "network"

  subnets = aws_subnet.public_subnet[*].id
  enable_deletion_protection = false
  security_groups            = [aws_security_group.lb_sg.id]
  enable_cross_zone_load_balancing = true
  tags = merge(var.tags, {
    Name = "${var.project_name}-lb"
  })
}

####################################################################################
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"  # TLS means HTTPS, but for NLB, we use TLS protocol for listener
  protocol          = "TCP" # This is mean by HTTP, but for NLB, we use TCP protocol for listener

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb.arn
  }
}

####################################################################################
resource "aws_lb_target_group" "aws_lb" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id     = aws_vpc.main.id

  health_check {
    enabled             = true
    protocol            = "TCP"
    port                = "traffic-port"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  
}

####################################################################################
resource "aws_lb_target_group_attachment" "web-ec2-attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.aws_lb.arn
  target_id        = aws_instance.web-1-ec2[count.index].id
  port             = 80
}

output "load_balancer_dns" {
  value = aws_lb.nlb.dns_name
}

output "ec2_private_ips" {
  value = aws_instance.web-1-ec2[*].private_ip
}

output "ec2_instance_ids" {
  value = aws_instance.web-1-ec2[*].id
}
