ASG is a regional horizontal scalablitiy as a service.

LB => TARGET GROUP [STATIC GROUP] FOR PREDICTIVE TRAFFIC
--------------------------------------------------------------------------
LOAD BALANCER CAN NOT ADD THE INSTANCES AUTO INSIDE THE TARGET GROUP
LOAD BALANCER CAN NOT PERFORM EC2 LEVEL HEALTH CHECKUP.
LOAD BALANCER CAN NOT REMOVE UNHEALTHY INSTANCES FROM TARGET GROUP.
TARGET GROUP DOES NOT AUTO SCALE INSTANCES.
--------------------------------------------------------------------------






ASG (DYNAMIC GROUP)
--------------------------------------------------------------------------
DO NOT ADD ANY INSTANCE INSIDE THE TARGET GROUP MANUALLY.

IF WE INTEGRATE ASG WITH TARGET GROUP, ALL THE INSTANCES WILL BE THE PART OF TG AUTOMATICALLY WHICH ARE AVAILABLE INSIDE ASG.

CAN WE CREATE ASG WITHOUT THE LOAD BALANCER ?
YES WE CAN CREATE BUT THAT ASG WILL BE TOTALLY USELESS DUE TO TRAFFIC DISTRIBUTION.

WHAT ARE THE LIMITATION OF ASG?
ASG CAN NOT PERFORM HEALTH CHECK OF APPLICATION. LOAD BALANCER CAN PERFORM APPLICATION HEALTH CHECKUP.
ASG CAN NOT DISTRIBUTE THE APPLICATION TRAFFIC INSIDE THE GROUP THAT'S WHY WE USE LB INFRONT OF ASG.

The Load Balancer performs the health checks on the targets registered in the Target Group. The health-check configuration is defined at the Target Group level.

ALB  → checks Application
TG   → defines ALB's health-check configuration
ASG  → decides whether to replace unhealthy EC2
EC2  → AWS performs infrastructure/status checks


By default, ASG uses EC2 health checks to determine whether an instance is unhealthy. If ELB health checks are enabled, ASG can also use the ELB/Target Group health status. When an instance is considered unhealthy, ASG terminates it and launches a replacement to maintain the desired capacity.

Scale out  => inceasing count of the instances
Scale in   => Decrease count of the instances

Behaviour of the ASG group-

a- Static Scaling  -> Human Interaction
b- Dynamic Scaling -> By Policies -> No Human Interaction
c- Scheduled Scaling -> Human Interaction

Components of ASG- 

Group: Collection of servers.
Note: We never create the instances manually. We use Lunch templates to launch auto EC2 instances.

LAUNCH TEMPLATE REQUIREMENTS: 

AMI ID 
INSTANCE TYPE
KEYPAIR
SECURTY GROUP
EBS VOLUME


