# Capstone 2: Theory & Concepts

Welcome to the 3-Tier Architecture! This is the most common architectural pattern for web applications.

## 1. Amazon RDS (Relational Database Service)
In the old days, companies had to provision EC2 instances, install PostgreSQL, configure backups, and handle server patches.
AWS RDS is a managed service. AWS handles the backups, patches, and high availability. You just provide the master username and password.

In Terraform, an RDS database requires two components:
1. **The Subnet Group (`aws_db_subnet_group`)**: RDS needs to know which subnets it is allowed to live in. You must create a Subnet Group and attach your Isolated Private Subnets to it.
2. **The DB Instance (`aws_db_instance`)**: The actual database. You specify the engine (postgres, mysql), instance class (e.g., `db.t3.micro`), and credentials.

## 2. The Security Matrix
This is where developers get tripped up. The architecture must be enforced by Security Groups.
- **ALB SG**: `Ingress: [Port 80, Source: 0.0.0.0/0]`
- **App SG (EC2)**: `Ingress: [Port 80, Source: ALB SG ID]`
- **Data SG (RDS)**: `Ingress: [Port 5432, Source: App SG ID]`

By strictly chaining Security Groups together, we guarantee that no one on the internet can hit your database directly. They *must* go through the Load Balancer, which talks to the App Servers, which talk to the Database.
