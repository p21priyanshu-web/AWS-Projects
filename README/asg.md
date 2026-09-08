AWS Auto Scaling Group (ASG) & Load Balancer
📌 Overview

ASG (Auto Scaling Group) is a regional service used for horizontal scalability of EC2 instances.

It works together with a Load Balancer (LB) and Target Group (TG) to automatically manage EC2 instances based on traffic, health, and scaling requirements.

Basic Architecture
                    🌐 Users
                       |
                       v
              +-------------------+
              |   Load Balancer   |
              |       (ALB)       |
              +-------------------+
                       |
                       v
              +-------------------+
              |   Target Group    |
              |   (Dynamic TG)    |
              +-------------------+
                       |
             +---------+---------+
             |         |         |
             v         v         v
           EC2       EC2       EC2
             ^         ^         ^
             |         |         |
             +---------+---------+
                       |
                       v
              Auto Scaling Group

🔵 Load Balancer (LB)

A Load Balancer distributes incoming application traffic across multiple EC2 instances.

The Load Balancer works with a Target Group.

Target Group

A Target Group contains the targets to which the Load Balancer sends traffic.

For example:

Load Balancer
      |
      v
Target Group
 ┌────┼────┐
 ↓    ↓    ↓
EC2  EC2  EC2

Important

A Target Group by itself does not automatically scale EC2 instances.

If instances are manually registered in a Target Group, it behaves like a static group.

For predictive/static traffic, manually registered targets may be sufficient, but for dynamic workloads we normally integrate the Target Group with an ASG.

❌ What a Load Balancer Cannot Do

A Load Balancer is responsible for traffic distribution and health checking, but it does not manage EC2 capacity.

LB cannot:
❌ Automatically launch new EC2 instances.
❌ Automatically add newly launched EC2 instances to a Target Group unless integrated with an ASG.
❌ Perform EC2 infrastructure-level/status checks.
❌ Decide the desired number of EC2 instances.
❌ Scale the number of EC2 instances up or down.
❌ Launch replacement EC2 instances when capacity is lost.

The Load Balancer can identify an unhealthy target, but ASG is responsible for replacing the instance when configured to use ELB health checks.

🟢 Auto Scaling Group (ASG)

An Auto Scaling Group manages a collection of EC2 instances and maintains the required capacity.

ASG provides horizontal scaling.

Horizontal Scaling
Scale Out
2 EC2 → 3 EC2 → 4 EC2


More instances are added when additional capacity is required.

Scale In
4 EC2 → 3 EC2 → 2 EC2


Instances are removed when less capacity is required.

🔥 ASG + Target Group Integration

When an ASG is integrated with a Target Group:

Do not manually add EC2 instances to the Target Group.

The ASG automatically registers instances that it launches with the Target Group.

Architecture
             Auto Scaling Group
                     |
          +----------+----------+
          |          |          |
          v          v          v
        EC2-1      EC2-2      EC2-3
          |          |          |
          +----------+----------+
                     |
                     v
               Target Group
                     ^
                     |
                     v
               Load Balancer
                     ^
                     |
                     |
                   Users


When ASG launches a new EC2 instance:

ASG launches EC2
       ↓
EC2 automatically becomes
part of the Target Group
       ↓
Load Balancer can send
traffic to the instance


When ASG terminates an EC2 instance:

ASG terminates EC2
       ↓
Instance is removed from
the Target Group

❓ Can We Create ASG Without a Load Balancer?
Yes ✅

An ASG can be created without a Load Balancer.

However, for a typical web/application workload, an ASG without a Load Balancer does not provide traffic distribution across the instances.

For example:

              Users
                |
                ?
        +-------+-------+
        |       |       |
       EC2     EC2     EC2

     No Load Balancer
     No traffic distribution


Therefore, for applications receiving distributed traffic, we commonly use:

Users
  |
  v
Load Balancer
  |
  v
Target Group
  |
  v
Auto Scaling Group
  |
  +---- EC2
  +---- EC2
  +---- EC2


Note: An ASG is not inherently useless without a Load Balancer—it can still provide automated EC2 provisioning, replacement, and scaling for workloads that don't require LB-based traffic distribution.

⚠️ Limitations of ASG

ASG manages EC2 capacity, but it is not responsible for distributing application traffic.

ASG cannot:
❌ Distribute application traffic.
❌ Act as a Load Balancer.
❌ Direct client requests to individual EC2 instances.
❌ Perform application-level health checks by itself.

For application-level health checking, we commonly use a Load Balancer.

❤️ Health Checks

There are multiple levels of health checking involved.

              AWS Infrastructure
                     |
                     v
              EC2 Status Check
                     |
                     v
             Auto Scaling Group
                     |
                     v
          ELB / Target Group Health
                     |
                     v
           Application Health

1. EC2 Infrastructure Health Check

AWS performs infrastructure/status checks on EC2 instances.

These checks help determine whether the underlying instance is functioning properly.

By default, ASG uses EC2 health checks to determine whether an instance is unhealthy.

2. Load Balancer Health Check

The Load Balancer performs health checks on targets registered in the Target Group.

The health-check configuration is defined at the Target Group level.

For example:

ALB
 |
 v
Target Group
 |
 +-- Health Check Configuration
       |
       +-- Protocol
       +-- Port
       +-- Path
       +-- Healthy Threshold
       +-- Unhealthy Threshold
       +-- Timeout
       +-- Interval


For an application, the health check could be:

GET /health


If the application responds successfully, the target can be considered healthy.

🔄 ASG + ELB Health Check

By default:

ASG
 |
 └── EC2 Health Check


If ELB health checks are enabled for the ASG, ASG can also use the health status reported by the Load Balancer/Target Group.

              Load Balancer
                    |
                    v
              Target Group
                    |
             Health Check
                    |
          +---------+---------+
          |                   |
       Healthy             Unhealthy
          |                   |
          v                   v
       Continue         ASG replaces EC2
                              |
                              v
                       Launch new EC2

Replacement Flow

If an instance is considered unhealthy:

Unhealthy EC2
      ↓
ASG detects unhealthy state
      ↓
ASG terminates instance
      ↓
ASG launches replacement
      ↓
New EC2 becomes part of Target Group
      ↓
Load Balancer performs health check
      ↓
Healthy instance receives traffic


The exact replacement behavior depends on the ASG health-check configuration and the reason the instance is unhealthy.

📈 ASG Scaling

ASG supports different scaling approaches.

1. Static Scaling

Human interaction is involved.

The desired capacity is manually changed.

Example:

Current:
3 EC2 instances

Administrator changes desired capacity:
3 → 5

ASG launches:
2 additional EC2 instances

Flow
Human
  ↓
Change desired capacity
  ↓
ASG
  ↓
Launch/terminate EC2

2. Dynamic Scaling

Scaling happens automatically based on configured policies.

No continuous human interaction is required.

Example:

CPU Utilization > 70%
          ↓
Scaling Policy
          ↓
ASG
          ↓
Launch additional EC2


Common scaling metrics/policies can include:

CPU utilization
Application Load Balancer request count
Network traffic
Custom CloudWatch metrics
Target tracking policies
Step scaling policies
Flow
Metric
  ↓
Scaling Policy
  ↓
ASG
  ↓
Scale Out / Scale In

3. Scheduled Scaling

Scaling occurs according to a predefined schedule.

Human interaction is required initially to configure the schedule, but the actual scaling occurs automatically at the scheduled time.

Example:

08:00 AM → Scale Out
        ↓
Increase EC2 capacity

08:00 PM → Scale In
        ↓
Decrease EC2 capacity


This is useful when traffic patterns are predictable.

🧩 Components of an Auto Scaling Group

An ASG primarily consists of:

Auto Scaling Group
│
├── Group
├── Launch Template
├── Desired Capacity
├── Minimum Capacity
├── Maximum Capacity
└── Scaling Policies

1. Group

The Auto Scaling Group is a logical collection of EC2 instances managed by ASG.

Example:

ASG
│
├── EC2-1
├── EC2-2
└── EC2-3

Important

We should not manually create the EC2 instances that are intended to be managed by the ASG.

Instead, ASG uses a Launch Template to create EC2 instances automatically.

🚀 Launch Template

A Launch Template contains the configuration ASG uses when launching new EC2 instances.

Common Launch Template Requirements
Launch Template
│
├── AMI ID
├── Instance Type
├── Key Pair
├── Security Group
└── EBS Volume

1. AMI ID

Defines the operating system and base image for the EC2 instance.

Examples:

Amazon Linux
Ubuntu
Windows Server

2. Instance Type

Defines the compute resources.

Examples:

t3.micro
t3.medium
m6i.large

3. Key Pair

Used for secure SSH access to Linux instances or other supported access mechanisms.

4. Security Group

Controls inbound and outbound network traffic for the EC2 instances.

5. EBS Volume

Defines the storage attached to the EC2 instance.

🏗️ Complete Architecture

The typical production architecture looks like this:

                         🌐 Internet
                              |
                              v
                    +-------------------+
                    |   Load Balancer   |
                    |       (ALB)       |
                    +-------------------+
                              |
                              v
                    +-------------------+
                    |   Target Group    |
                    | Health Check: /   |
                    |      health       |
                    +-------------------+
                              |
             +----------------+----------------+
             |                |                |
             v                v                v
          +------+         +------+         +------+
          | EC2  |         | EC2  |         | EC2  |
          |  #1  |         |  #2  |         |  #3  |
          +------+         +------+         +------+
             ^                ^                ^
             |                |                |
             +----------------+----------------+
                              |
                              v
                    +-------------------+
                    | Auto Scaling Group|
                    +-------------------+
                              |
                              v
                    +-------------------+
                    |  Launch Template  |
                    +-------------------+
                              |
                              v
                    +-------------------+
                    | AMI / Type / SG   |
                    | Key Pair / EBS    |
                    +-------------------+

🧠 Quick Comparison
Feature	Load Balancer	Target Group	Auto Scaling Group
Distributes traffic	✅	❌	❌
Application health check	✅	Configuration is defined here	Can use ELB health status
EC2 infrastructure health	❌	❌	✅
Launch EC2	❌	❌	✅
Terminate/replace EC2	❌	❌	✅
Scale Out	❌	❌	✅
Scale In	❌	❌	✅
Automatically register ASG instances	Via ASG integration	Receives registered instances	✅
Uses Launch Template	❌	❌	✅
🎯 Key Takeaways

Load Balancer = Traffic Distribution

Target Group = Collection of Targets + Health Check Configuration

Auto Scaling Group = EC2 Capacity Management

Launch Template = Blueprint for Creating EC2 Instances

Remember the flow:
                 USER TRAFFIC
                      |
                      v
                LOAD BALANCER
                      |
                      v
                TARGET GROUP
                      |
                      v
               EC2 INSTANCES
                      ^
                      |
             AUTO SCALING GROUP
                      ^
                      |
               LAUNCH TEMPLATE

In one sentence:

ALB distributes application traffic → Target Group defines the targets and health checks → ASG manages EC2 capacity → Launch Template tells ASG how to launch new EC2 instances.
Done.