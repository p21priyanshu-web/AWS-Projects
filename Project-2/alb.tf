# #############################################################################################
# resource "aws_lb" "nlb" {
#   name               = "${var.project_name}-nlb"
#   internal           = false
#   load_balancer_type = "network"

#   subnets                    = var.public_subnet[*].id
#   enable_deletion_protection = false

#   tags = merge(var.tags, {
#     Name = "${var.project_name}-lb"
#   })

# }

# ####################################################################################

# resource "aws_lb_target_group" "aws_lb" {
#   name        = "${var.project_name}-tg"
#   port        = "80"
#   protocol    = "TCP"
#   target_type = "instance"

#   health_check {
#     enabled  = true
#     protocol = "TCP"
#     port     = "traffic-port"
#   }
# }

# #############################################################################################
