## Project 2 — Highly Available Web Application on AWS
                         Internet
                            │
                            ▼
                  ┌─────────────────┐
                  │       ALB       │
                  │  Public Subnets │
                  └────────┬────────┘
                           │
                    HTTP : 80
                           │
             ┌─────────────┴─────────────┐
             ▼                           ▼
       ┌────────────┐              ┌────────────┐
       │    EC2     │              │    EC2     │
       │  Private   │              │  Private   │
       │    AZ-1    │              │    AZ-2    │
       └─────┬──────┘              └─────┬──────┘
             │                           │
             └──────────┬────────────────┘
                        ▼
                   NAT Gateway
                        │
                     Internet

VPC/subnets from Project 1
Application Load Balancer (ALB)
EC2 Launch Template
Auto Scaling Group (ASG)
IAM Instance Role
Security Groups
Target Group
Health Checks
CloudWatch monitoring
SSM-based management
Terraform dependencies and outputs


Company: Acme Commerce Pvt. Ltd.
Application: acme-commerce-web
Environment: prod
********************************************************************
The application must:

Be accessible from the internet
Run behind an ALB
Have EC2 instances in private subnets
Run across 2 Availability Zones
Automatically replace unhealthy instances
Scale between minimum and maximum capacity
Use an IAM role instead of static AWS credentials
Allow administration through AWS Systems Manager
Restrict security-group traffic according to the architecture
Use ALB health checks
Have CloudWatch monitoring
Be completely managed through Terraform
********************************************************************