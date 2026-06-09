# Module 4: Advanced HCL (Loops, Conditions, and Dynamic Blocks)

As your infrastructure grows, you'll need to create multiple similar resources, apply conditional logic, or generate nested blocks dynamically. HCL provides several powerful features to handle these scenarios.

## 1. `count`
The `count` meta-argument allows you to create multiple instances of a resource based on a number.

```hcl
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  
  tags = {
    Name = "WebServer-${count.index + 1}"
  }
}
```
*Note: `count.index` starts at 0, so the servers will be named WebServer-1, WebServer-2, WebServer-3.*

## 2. `for_each`
While `count` is great for identical resources, `for_each` is better when you need to create multiple resources that have distinct configurations, usually based on a map or a set of strings.

```hcl
variable "subnet_cidrs" {
  type    = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

resource "aws_subnet" "main" {
  for_each          = var.subnet_cidrs
  vpc_id            = "vpc-12345" # Assuming an existing VPC
  availability_zone = each.key
  cidr_block        = each.value
}
```

## 3. Conditional Expressions
Terraform supports a ternary syntax (`condition ? true_val : false_val`) for conditional logic.

```hcl
variable "is_production" {
  type    = bool
  default = false
}

resource "aws_instance" "server" {
  ami           = "ami-123456"
  # Use a larger instance type for production
  instance_type = var.is_production ? "t3.large" : "t3.micro"
}
```

## 4. Dynamic Blocks
Some resources contain nested blocks (like `ingress` and `egress` rules inside an `aws_security_group`). You can generate these dynamically using a `dynamic` block.

```hcl
variable "ingress_ports" {
  type    = list(number)
  default = [80, 443, 8080]
}

resource "aws_security_group" "web_sg" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

---
**Why this matters**: Advanced HCL allows you to keep your code DRY (Don't Repeat Yourself). Instead of writing 10 separate security group rules manually, you write one dynamic block and pass a list of ports!

Go to `assignment/README.md` to begin your hands-on work.
