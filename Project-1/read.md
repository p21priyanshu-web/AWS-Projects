# AWS VPC Networking with Terraform

Reusable **AWS VPC networking setup using Terraform** for application infrastructure.

This repository creates a basic but production-oriented network structure with **Public + Private Subnets across 2 Availability Zones**.

## 🏗️ Architecture

```text
                         Internet
                            |
                     Internet Gateway
                       /           \
                      /             \
             Public Subnet 1     Public Subnet 2
             10.10.1.0/24        10.10.2.0/24
             ap-south-1a         ap-south-1b
                  |                   |
             NAT Gateway 1       NAT Gateway 2
                  |                   |
                  |                   |
             Private Subnet 1   Private Subnet 2
             10.10.11.0/24      10.10.12.0/24
             ap-south-1a         ap-south-1b
```

## 🔧 What This Creates

* 1 VPC — `10.10.0.0/16`
* 2 Public Subnets
* 2 Private Subnets
* 1 Internet Gateway
* 2 NAT Gateways
* 2 Elastic IPs
* Public Route Table
* 2 Private Route Tables
* Route Table Associations
* VPC DNS Support & DNS Hostnames

## 🔄 How It Works

### Public Subnet

Public resources can reach the Internet through the Internet Gateway.

```text
Public Subnet
     ↓
Route Table
     ↓
Internet Gateway
     ↓
Internet
```

Typical use:

* Load Balancer
* Bastion Host
* Public-facing resources

### Private Subnet

Private resources don't have direct Internet access.

For outbound Internet traffic, they use a NAT Gateway.

```text
Private Subnet
     ↓
NAT Gateway
     ↓
Internet Gateway
     ↓
Internet
```

Typical use:

* Application Servers
* Backend Services
* ECS/EKS workloads
* Databases
* Internal services

## 💡 When Should You Use This?

This repository is useful when you need a new AWS network for an application such as:

```text
Application
   |
   ├── Load Balancer → Public Subnet
   |
   ├── Backend       → Private Subnet
   |
   └── Database      → Private Subnet
```

Good use cases:

* New AWS application
* Development environment
* Staging environment
* Production foundation
* EC2-based applications
* ECS/EKS infrastructure
* Backend + database architecture

## 🚀 How to Use

### 1. Clone

```bash
git clone <REPOSITORY-URL>
cd <REPOSITORY-DIRECTORY>
```

### 2. Configure AWS

Make sure AWS credentials are configured:

```bash
aws configure
```

Verify:

```bash
aws sts get-caller-identity
```

### 3. Update Variables

Edit:

```text
terraform.tfvars
```

Change:

* Project name
* VPC CIDR
* Subnet CIDRs
* Availability Zones
* Resource names

### 4. Deploy

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Confirm with:

```text
yes
```

### 5. Destroy

To remove the infrastructure:

```bash
terraform destroy
```

## 📁 Files

```text
├── aws_network.tf      # VPC, subnets, NAT, IGW, routes
├── providers.tf        # Terraform & AWS provider
├── variables.tf        # Input variables
├── terraform.tfvars    # Configuration values
└── README.md
```

## 💰 Cost Note

This setup creates **2 NAT Gateways**.

NAT Gateways have AWS charges, so they can increase the cost of the environment.

* Development → consider 1 NAT Gateway
* Production → 2 NAT Gateways provide better AZ resilience

## ⚠️ Before Using in Production

This repository provides the **network foundation**. You should additionally configure:

* Security Groups
* IAM permissions
* Network ACLs where required
* VPC Flow Logs
* Monitoring
* Logging
* VPC Endpoints

Also, never commit AWS credentials or Terraform state files to a public GitHub repository.

## ⭐ Why Use This Repository?

Instead of manually creating:

```text
VPC
 ↓
Subnets
 ↓
Internet Gateway
 ↓
NAT Gateways
 ↓
Route Tables
 ↓
Associations
```

you can create the complete network with a few Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

**Clone → Configure → Plan → Apply → Ready AWS Network.**
