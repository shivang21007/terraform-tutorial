# Capstone 2: Multi-tier Architecture

You already know how to build the Presentation and Compute tiers. We are going to reuse a lot of your knowledge from Capstone 1, but we are adding the Data Tier!

## Part 1: The Network Module
Inside `modules/networking/`:
*(Hint: You can copy your Capstone 1 code or use the official `terraform-aws-modules/vpc/aws` module, but you must add the data subnets!)*
1. **VPC**: Create your VPC.
2. **Subnets (6 Total!)**:
   - **2 Public Subnets** (For the ALB & NAT Gateway)
   - **2 Private App Subnets** (For your EC2 instances)
   - **2 Private Database Subnets** (Isolated - for your Database)
3. **Routing**:
   - Public Subnets route to the Internet Gateway.
   - App Subnets route to the NAT Gateway (which lives in the public subnet).
   - Database Subnets do **not** route to the internet. They have no route to the IGW or NAT.
4. **Outputs**: Output all 3 types of Subnet IDs and the VPC ID.

## Part 2: The Compute Module
Inside `modules/compute/`:
This is almost exactly the same as Capstone 1!
- Rebuild your ALB, Target Group, and ASG.
- Rebuild your Launch Template.
- **Security Groups**: 
  - `alb_sg` (Allows 80 from 0.0.0.0/0)
  - `app_sg` (Allows 80 from `alb_sg`)
- **Outputs**: Output the `app_sg` ID so the database module can use it!

## Part 3: The Database Module
Inside `modules/database/`:
This module needs variables: `vpc_id`, `database_subnet_ids`, and `app_sg_id`.
1. **Subnet Group (`aws_db_subnet_group`)**: Attach your `database_subnet_ids` here.
2. **Security Group (`aws_security_group`)**: Allow Inbound Port `5432` (Postgres) *only* from the Compute Module's `app_sg_id`.
3. **RDS Instance (`aws_db_instance`)**:
   - `engine` = `"postgres"`
   - `instance_class` = `"db.t3.micro"`
   - `allocated_storage` = `20`
   - `db_subnet_group_name` = reference your Subnet Group!
   - `vpc_security_group_ids` = reference your RDS Security Group!
   - `username` = `"dbadmin"`
   - `password` = `"supersecretpassword"`
   - `skip_final_snapshot` = `true` (Crucial so `terraform destroy` works later).

## Part 4: Assembly
In your root `main.tf`:
1. Define the AWS Provider.
2. Call your `networking` module.
3. Call your `compute` module (pass in the networking outputs).
4. Call your `database` module (pass in the networking Data Subnets and the Compute Security Group ID).

Run `terraform apply`! (Warning: RDS databases take about 5-8 minutes to spin up).
