# Assignment 3: Making Terraform Dynamic

Your goal for this assignment is to write a dynamic Terraform configuration. You will use Variables, Outputs, and Data Sources to avoid hardcoding values.

## Requirements

1. **Setup**: Create your `main.tf`, `variables.tf`, and `outputs.tf` in this directory.
2. **Provider**: Configure the `aws` provider. Instead of hardcoding the region, try using a variable (e.g., `var.aws_region`) in the provider block.
3. **Variables**: 
   - Create a variable for the AWS region (e.g., `aws_region`) with a default value.
   - Create a variable for the EC2 instance type (e.g., `instance_type`) with a default of `t3.micro`.
4. **Data Source**: 
   - Instead of hardcoding an `ami` ID, use the `aws_ami` data source to fetch the latest Amazon Linux 2 AMI. 
   - *Hint:* You can use the data source snippet from the `theory.md` file!
5. **Resource**: 
   - Create an `aws_instance`.
   - Set the `ami` argument to the ID from your data source (`data.aws_ami.YOUR_DATA_SOURCE_NAME.id`).
   - Set the `instance_type` to your variable (`var.instance_type`).
6. **Outputs**:
   - Create an output named `public_ip` that returns the public IP of your EC2 instance.

*Note: For this module, you do not need to use the S3 backend (you can rely on local state to keep it simple and avoid overriding the previous module's state), or you can configure a different `key` for your S3 backend block.*

## Instructions

1. `tf init`
2. `tf plan` - Notice how the plan resolves your variables and data sources.
3. `tf apply` - After it completes, look at the bottom of the output in your terminal. You should see `Outputs:` with the public IP of your new server!
4. When you are done playing around, remember to run `tf destroy` to clean up your resources.

Let me know when you finish this assignment!
