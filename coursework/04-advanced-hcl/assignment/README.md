# Assignment 4: Advanced HCL

Your goal for this assignment is to use `count`, conditional expressions, and dynamic blocks to make your configuration smarter.

## Requirements

1. **Setup**: Create your `main.tf` and `variables.tf` in this directory.
2. **Provider**: Configure your `aws` provider (feel free to hardcode the region for simplicity here, e.g. `us-east-1`).
3. **Variables**: 
   - Create a variable called `create_servers` of type `bool` with a default of `true`.
   - Create a variable called `server_count` of type `number` with a default of `2`.
   - Create a variable called `web_ports` of type `list(number)` with a default of `[80, 443]`.
4. **Conditionals & Count**:
   - Create an `aws_instance` resource.
   - Use `count` combined with a conditional: if `var.create_servers` is true, the count should be `var.server_count`, otherwise it should be `0`. (Hint: `count = var.create_servers ? var.server_count : 0`)
   - Set the `Name` tag to include the index, like `"Web-Server-0"`, `"Web-Server-1"`. (Hint: use `${count.index}`)
   - *Tip*: You can use the `aws_ami` data source from the previous module to fetch the AMI.
5. **Dynamic Blocks**:
   - Create an `aws_security_group` named `"dynamic-sg"`.
   - Inside it, use a `dynamic "ingress"` block to loop over `var.web_ports`.
   - For each port, set `from_port` and `to_port` to `ingress.value`, `protocol` to `"tcp"`, and `cidr_blocks` to `["0.0.0.0/0"]`.

## Instructions

1. `tf init`
2. `tf plan` - Verify that it plans to create 2 EC2 instances and 1 Security Group with 2 ingress rules.
3. Try changing `create_servers` to `false` in a `terraform.tfvars` file or via `-var="create_servers=false"` on the CLI and see how `tf plan` changes! (It should plan to create 0 instances).
4. `tf apply` - Provision your dynamic resources!
5. When finished, don't forget to run `tf destroy` to clean up.

Let me know when you finish this assignment!
