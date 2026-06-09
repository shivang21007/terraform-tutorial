# Module 6: Mini-Project 1 - The Web Tier

Congratulations on making it this far! You've learned the core building blocks of Terraform: Providers, State, Variables, Outputs, Data Sources, Loops, and Modules.

Now it's time to put it all together without step-by-step handholding. You've been promoted to Junior DevOps Engineer, and your first task is to deploy a scalable Web Tier.

## Architecture Requirements

You need to write a Terraform configuration that provisions the following:

1. **A Security Group**:
   - Create an `aws_security_group`.
   - Use a `dynamic "ingress"` block.
   - It must allow inbound TCP traffic on ports `80` (HTTP), `443` (HTTPS), and `22` (SSH).
   - It must allow all outbound traffic (`egress` port `0`, protocol `"-1"`).

2. **A Custom EC2 Module**:
   - Create a local module in a `modules/ec2-instance/` directory.
   - Your module should accept variables for the `instance_type`, `ami_id`, `security_group_id`, and `server_name`.
   - The module should use a `user_data` script (using the `file()` function, feel free to use the script from the previous module or write a simple bash script to install nginx) so the server boots up as a web server.
   - The module must output the public IP of the instance it creates.

3. **The Root Deployment**:
   - Use a `data` source in your root `main.tf` to fetch the latest Amazon Linux 2 or Ubuntu 24.04 AMI.
   - Deploy **3** web servers by calling your custom EC2 module. You can use the `count` meta-argument on the module block! (e.g. `count = 3`).
   - Pass the dynamic AMI ID and the security group ID into the module.

4. **Outputs**:
   - Your root module must output a list of all three public IP addresses of your newly created web servers by pulling them from the child module.

## Instructions

1. Work entirely inside the `assignment/` folder in this directory.
2. Structure your code cleanly (e.g., separating `main.tf`, `variables.tf`, `outputs.tf`).
3. Run your standard Terraform workflow (`init`, `plan`, `apply`).
4. Prove it works by curling the public IPs to see the web server response.
5. When you are done, run `tf destroy` and let me know you've completed Mini-Project 1! Good luck!
