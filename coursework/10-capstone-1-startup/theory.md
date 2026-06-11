# Capstone 1: Theory & Concepts

Welcome to your first Capstone! You asked about S3 + DynamoDB state locking. Is it an "old" method? 
Actually, no! While HashiCorp pushes people towards their paid "Terraform Cloud" product, using an S3 Bucket + DynamoDB Table remains the **absolute gold standard** for AWS-native engineering teams. It is secure, fully integrated into AWS IAM, and incredibly cheap.

In this project, we are introducing two massive new AWS concepts: **Load Balancing** and **Auto Scaling**.

## 1. The Application Load Balancer (ALB)
If you have 10 servers running your website, you don't want to give your customers 10 different IP addresses. You want to give them one domain name.
The ALB sits in your **Public Subnet** and receives all traffic from the internet. It then looks at its routing rules and forwards the traffic evenly to your backend servers in the **Private Subnet**.

In Terraform, an ALB requires three components:
1. **The Load Balancer (`aws_lb`)**: The actual hardware sitting in the public subnet.
2. **The Target Group (`aws_lb_target_group`)**: A logical "bucket" where your backend servers register themselves. The ALB constantly sends "Health Checks" to this bucket to make sure the servers are alive.
3. **The Listener (`aws_lb_listener`)**: The port the ALB listens on (e.g., Port 80). It connects the Load Balancer to the Target Group (saying "If traffic hits Port 80, forward it to Target Group X").

## 2. Auto Scaling Groups (ASG)
What happens if you suddenly go viral on Twitter and get 1 million visitors? 
Instead of manually creating EC2 instances, we use an Auto Scaling Group.

In Terraform, an ASG requires two components:
1. **The Launch Template (`aws_launch_template`)**: A blueprint. It defines exactly *how* to build a new server (AMI, Instance Type, Security Groups, User Data script).
2. **The Auto Scaling Group (`aws_autoscaling_group`)**: The manager. It uses the Launch Template to spin up servers. You tell it: "Keep a minimum of 2 servers running, but if CPU spikes, scale up to 4." 
  - The ASG automatically registers its newly created servers into the ALB's Target Group!
