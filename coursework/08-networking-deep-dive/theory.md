# Module 8: Networking Deep Dive (VPC from Scratch)

Up to this point, we have been deploying our EC2 instances into your AWS account's **Default VPC**. However, in a real production environment, relying on the default VPC is considered a major security risk.

As a DevOps Engineer, you are expected to design and build custom Virtual Private Clouds (VPCs) with strict network boundaries. Before we write Terraform code, let's revise exactly how an AWS Network operates.

## The Big Picture Diagram

Here is a visual representation of a standard production AWS Network architecture:

![AWS VPC Diagram](./aws_vpc_diagram.png)

## The Components in Detail

### 1. VPC (`aws_vpc`)
Think of the VPC as the walls of your data center. It is an isolated section of the AWS cloud. You assign it a large block of IP addresses (a CIDR block).
- Example: `10.0.0.0/16` gives you 65,536 private IP addresses.
- Nothing gets in or out of these walls unless you explicitly create a door.

### 2. Subnets (`aws_subnet`)
You slice the VPC's massive block of IPs into smaller chunks called subnets. A subnet must live inside a specific Availability Zone (e.g., `us-east-1a`).
- **Public Subnet**: A subnet is "Public" if its traffic has a direct path to the public internet. We put Load Balancers, Web Servers, and NAT Gateways here.
- **Private Subnet**: A subnet is "Private" if its traffic cannot directly reach the internet. We put backend servers and Databases here for maximum security.

### 3. Internet Gateway (`aws_internet_gateway` / IGW)
The IGW is the literal "door" to your VPC. It connects your VPC to the outside internet. Without an IGW, your VPC is a completely sealed black box.

### 4. Route Tables (`aws_route_table`)
Route tables act as the "Traffic Cops" of your network. Every subnet must be associated with a Route Table, which contains a list of rules (Routes) telling network traffic where to go.
- **Public Route Table**: Has a rule saying "If traffic wants to go to the internet (`0.0.0.0/0`), send it to the Internet Gateway".
- **Private Route Table**: Does *not* have a rule pointing to the IGW. Instead, it might have a rule pointing to a NAT Gateway.

### 5. NAT Gateway (`aws_nat_gateway`)
What happens if your Database in a Private Subnet needs to download a software update? It can't use the IGW because it's private!
- A NAT (Network Address Translation) Gateway sits in the **Public Subnet**.
- Your private servers send their outbound requests to the NAT Gateway. 
- The NAT Gateway uses its own public IP to fetch the update from the internet and hands it back to the private server. 
- It acts like a one-way mirror: private servers can reach out, but hackers on the internet cannot initiate a connection back in.

### 6. Network Access Control Lists (NACLs) (`aws_network_acl`)
While Security Groups act as a firewall at the **Instance level** (protecting individual EC2 servers), NACLs act as a firewall at the **Subnet level**. 
- Think of a NACL as a bouncer at the door of the Subnet. Even if an EC2 Security Group allows traffic, the NACL can block it before it even enters the subnet.
- **Stateless vs Stateful**: Security Groups are *stateful* (if you allow an incoming request, the response is automatically allowed back out). NACLs are *stateless* (if you allow incoming traffic on port 80, you must explicitly write a rule to allow the outgoing response).
- **Default Behavior**: By default, AWS creates a NACL for your VPC that allows *all* inbound and outbound traffic. You generally only configure custom NACLs for advanced security requirements (like explicitly blacklisting a known malicious IP address).

## How to Build It (The Workflow)
To build a functional public network from scratch, you must follow this exact order:
1. Create the **VPC**.
2. Create the **Subnet** inside that VPC.
3. Create the **Internet Gateway (IGW)** and attach it to the VPC.
4. Create a **Route Table** that routes `0.0.0.0/0` (all internet traffic) to the IGW.
5. **Associate** the Route Table with your Subnet using an `aws_route_table_association`.

If you miss step 5, your subnet will use the VPC's hidden "main" route table (which doesn't know about the IGW), and your servers will have no internet connection!
