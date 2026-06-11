# Capstone 1: The Startup Launch (SkyNet E-Commerce)

Here is your detailed guide. Since this is your first time dealing with ALB/ASG and complex modules, I will outline exactly what resources belong where.

## Part 1: The State Backend
Before you build anything, you need a place to store state.
1. Create a folder called `backend-setup/` inside the assignment directory.
2. Write a quick `main.tf` there to deploy an `aws_s3_bucket` (enable versioning!) and an `aws_dynamodb_table` (must have a Hash Key named `LockID` of type String).
3. `terraform apply` this. Now you have your backend infrastructure!
4. In your main project folder (`assignment/`), create your `provider.tf` and include the `backend "s3" {}` block pointing to your new bucket and table.

## Part 2: The Networking Module
Inside `modules/networking/`:
Create a custom VPC architecture just like you did in Module 8, but we need **two** of everything for High Availability.
1. **VPC**: CIDR `10.0.0.0/16`.
2. **Public Subnets (2)**: 
   - Subnet 1: `10.0.1.0/24` in `us-east-1a`
   - Subnet 2: `10.0.2.0/24` in `us-east-1b`
3. **Private Subnets (2)**:
   - Subnet 1: `10.0.3.0/24` in `us-east-1a`
   - Subnet 2: `10.0.4.0/24` in `us-east-1b`
4. **Internet Gateway**: Attached to VPC.
5. **Route Tables**: Route public subnets to the IGW. *(For this project, to save costs, we will skip the NAT Gateway. This means your private servers won't be able to run `apt-get update`, so keep your `user_data` script simple!)*.
6. **Outputs**: You must output the `vpc_id`, a list of the `public_subnet_ids`, and a list of the `private_subnet_ids` so the Compute module can use them.

## Part 3: The Compute Module
Inside `modules/compute/`:
This module needs variables: `vpc_id`, `public_subnet_ids`, and `private_subnet_ids`.

1. **Security Groups**:
   - `alb_sg`: Allow Port 80 from `0.0.0.0/0`.
   - `ec2_sg`: Allow Port 80 *only* from `alb_sg.id`.
2. **Application Load Balancer (`aws_lb`)**:
   - `load_balancer_type = "application"`
   - Attach it to the `public_subnet_ids` and the `alb_sg`.
3. **Target Group (`aws_lb_target_group`)**:
   - Port 80, Protocol HTTP, attach it to the `vpc_id`.
4. **Listener (`aws_lb_listener`)**:
   - Port 80, default action type `forward` to your Target Group ARN.
5. **Launch Template (`aws_launch_template`)**:
   - AMI: Ubuntu, Instance type: `t3.micro`.
   - `vpc_security_group_ids`: `[ec2_sg.id]`
   - `user_data`: Provide a script that simply runs a basic Python HTTP server on port 80 saying "Welcome to SkyNet", since we don't have internet access to install NGINX. Example:
     ```bash
     #!/bin/bash
     echo "<h1>Welcome to SkyNet E-Commerce</h1>" > index.html
     nohup python3 -m http.server 80 &
     ```
   - **Crucial**: Use `base64encode()` on your user_data script string in Terraform!
6. **Auto Scaling Group (`aws_autoscaling_group`)**:
   - `vpc_zone_identifier`: Attach to `private_subnet_ids`.
   - `target_group_arns`: Attach to your Target Group ARN (this tells the ASG to register its instances to the Load Balancer!).
   - Min size: 2, Max size: 4.
   - Link it to the Launch Template using the `launch_template {}` block.

## Part 4: Assembly
In your root `assignment/main.tf`, call your `networking` module, and then call your `compute` module (passing the networking outputs into the compute inputs).

Run `terraform apply` and browse to the ALB's DNS Name!
