# Assignment 8: The Custom Network (Pro Edition)

It's time to build your own network. Since this is your first time building a VPC without a pre-built module, here is a step-by-step guide with the exact resource names you will need. We are building a full Production-Ready Network Architecture.

## Architecture Goal
You will build:
1. A **Custom VPC**.
2. A **Public Subnet** with an Internet Gateway.
3. A **Private Subnet** with a NAT Gateway.
4. A **Public EC2 Instance (Bastion Host)** that you can reach from the Internet.
5. A **Private EC2 Instance** that can only be reached from the Bastion Host.
6. **Security Groups** that restrict traffic perfectly.

## Your Task

Create a `main.tf` file and set up your AWS provider. Then, provision the following resources in order. *Hint: Use variables to keep it clean!*

### 1. The VPC
- **Resource Block**: `aws_vpc`
- **Required Arguments**: `cidr_block = "10.0.0.0/16"`
- **Tags**: Give it a Name tag of `custom-vpc`
- **Explanation**: This creates the main boundary of your entire network.

### 2. The Internet Gateway (IGW)
- **Resource Block**: `aws_internet_gateway`
- **Required Arguments**: `vpc_id` (Reference your VPC)
- **Tags**: Give it a Name tag of `custom-igw`
- **Explanation**: This is the door that connects your VPC to the outside world.

### 3. The Public Subnet
- **Resource Block**: `aws_subnet`
- **Required Arguments**: 
  - `vpc_id` (Reference your VPC)
  - `cidr_block = "10.0.1.0/24"`
  - `availability_zone = "us-east-1a"` *(Explicitly placing the subnet in a specific data center)*
  - `map_public_ip_on_launch = true` *(This is critical so EC2 instances inside it get a public IP automatically!)*
- **Tags**: Give it a Name tag of `public-subnet`

### 4. The Public Route Table & Association
- **Resource Block**: `aws_route_table`
- **Required Arguments**: `vpc_id`
- **How to route traffic**: Inside the block, create a `route {}` block. Tell it to send internet traffic (`0.0.0.0/0`) to your IGW.
  ```hcl
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  ```
- **Association**: Create an `aws_route_table_association` resource that links your **Public Subnet ID** to this **Route Table ID**.
- **Resource Block**: `aws_route_table_association`
- **Required Arguments**: `subnet_id` (Reference your Public Subnet) , `route_table_id` (Reference your Public Route Table)
- ```hcl 
  resource "aws_route_table_association" "my-table-association" {
  subnet_id = aws_subnet.my-pub-subnet.id
  route_table_id = aws_route_table.my-aws_route_table.id
  }
  ```

### 5. The Private Subnet
- **Resource Block**: `aws_subnet`
- **Required Arguments**: 
  - `vpc_id`
  - `cidr_block = "10.0.2.0/24"`
  - `availability_zone = "us-east-1b"` *(Explicitly placing the subnet in a specific data center)*
- **Tags**: Give it a Name tag of `private-subnet`
- **Explanation**: We do *not* add `map_public_ip_on_launch = true` here. Servers in this subnet should not have public IPs.

### 6. The NAT Gateway
- **Resource Block 1**: `aws_eip`
  - **Required Arguments**: `domain = "vpc"`
  - **Explanation**: A NAT Gateway requires a dedicated, static Public IP (an Elastic IP) to function.
- **Resource Block 2**: `aws_nat_gateway`
  - **Required Arguments**:
    - `allocation_id` (Reference the ID of the `aws_eip` you just created)
    - `subnet_id` (Reference your **Public Subnet ID**, *not* the private one. The NAT must live in the public zone to reach the internet!)

### 7. The Private Route Table & Association
- **Resource Block**: `aws_route_table`
- **Required Arguments**: `vpc_id`
- **How to route traffic**: Inside the block, create a `route {}` block. Tell it to send internet traffic (`0.0.0.0/0`) to your **NAT Gateway**, *not* the IGW.
  ```hcl
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
  ```
- **Association**: Create an `aws_route_table_association` resource that links your **Private Subnet ID** to this **Private Route Table ID**.
```hcl 
   resource "aws_route_table_association" "my-private-table-association" {
  subnet_id = aws_subnet.my-priv-subnet.id
  route_table_id = aws_route_table.my-aws-private-route-table.id
}
```

### 8. Security Groups
- **Public SG (`aws_security_group`)**:
  - **Required Arguments**: `name` & `vpc_id` (Reference your custom VPC!)
  - Allow inbound Port 22 (SSH) and Port 80 (HTTP) from `cidr_blocks = ["0.0.0.0/0"]`.
  - Allow all outbound (`egress { from_port=0 to_port=0 protocol="-1" cidr_blocks=["0.0.0.0/0"] }`).
- **Private SG (`aws_security_group`)**:
  - **Required Arguments**: `name` & `vpc_id` (Reference your custom VPC!)
  - Allow inbound Port 22 and Port 80 *only* from the Public SG!
    ```hcl
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      security_groups = [aws_security_group.public_sg.id] # Reference the ID!
    }
    ```
  - Allow all outbound.

### 9. The Servers
- **Public Bastion Host (`aws_instance`)**: Place in Public Subnet. Attach the Public SG. Add a `user_data` script to install NGINX. Assign your SSH key pair.
```hcl
resource "aws_instance" "my-public-host" {
  depends_on = [aws_key_pair.terraform-key]
  ami = "ami-0021ac0c2e69d9c55"
  key_name = aws_key_pair.terraform-key.key_name
  instance_type = "t3.micro"
  
  subnet_id = aws_subnet.my-pub-subnet.id
  vpc_security_group_ids = [aws_security_group.my-pub-sg.id]
  user_data = file("${path.module}/install.sh")
  tags = {
    Name = "public-host"
  }
}
```

- **Private Server (`aws_instance`)**: Place in Private Subnet. Attach the Private SG. Add a `user_data` script to install NGINX. Assign your SSH key pair.
```hcl
resource "aws_instance" "my-private-host" {
  depends_on = [aws_key_pair.terraform-key]
  ami = "ami-0021ac0c2e69d9c55"
  key_name = aws_key_pair.terraform-key.key_name
  instance_type = "t3.micro"

  subnet_id = aws_subnet.my-priv-subnet.id
  vpc_security_group_ids = [aws_security_group.my-priv-sg.id]
  user_data = file("${path.module}/install.sh")
  tags = {
    Name = "private-host"
  }
}
```

## The Ultimate Test
Once applied:
1. `curl` the public IP of the Bastion host. You should see NGINX! 
2. Try to `curl` or ping the Private Server from your laptop. It should fail.
3. SSH into the Bastion Host using your private key.
4. From *inside* the Bastion Host, run `curl <private-ip-of-private-server>`. It should return NGINX!
