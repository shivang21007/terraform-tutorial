# Assignment 5: Building and Consuming a Module

In this assignment, you are going to create a reusable EC2 server module and then call it from your root directory.

## Requirements

### Part 1: Create the Child Module
1. Inside this `assignment` directory, create a new folder named `modules`.
2. Inside `modules`, create another folder named `web-server`. 
   *(Your path should be: `assignment/modules/web-server/`)*
3. Inside the `web-server` directory, create a `main.tf` and a `variables.tf`.
4. In `modules/web-server/variables.tf`, define two variables:
   - `ami_id` (type: string)
   - `instance_name` (type: string)
5. In `modules/web-server/main.tf`, write an `aws_instance` resource:
   - Set the `ami` to `var.ami_id`
   - Set the `instance_type` to `"t3.micro"`
   - Set the `tags.Name` to `var.instance_name`
6. *(Optional)* Create an `outputs.tf` in the `web-server` folder and output the `aws_instance`'s `public_ip`.

### Part 2: Consume the Child Module (Root Directory)
1. Go back to the root `assignment/` directory.
2. Create your main root `main.tf` file.
3. Configure your `aws` provider as usual.
4. Call your child module using a `module` block:
   ```hcl
   module "frontend_server" {
     source        = "./modules/web-server"
     
     # Grab an AMI ID (like the Ubuntu one we used earlier) or set up a data block!
     ami_id        = "ami-0021ac0c2e69d9c55" 
     instance_name = "Frontend-Prod"
   }
   ```
5. *(Optional)* Call the module **a second time** with a different name to provision a backend server effortlessly!
   ```hcl
   module "backend_server" {
     source        = "./modules/web-server"
     ami_id        = "ami-0021ac0c2e69d9c55"
     instance_name = "Backend-Prod"
   }
   ```

## Instructions
1. Run `tf init`. **(Crucial step! `init` is what downloads the child module code into your root `.terraform/` folder!)**
2. Run `tf plan`. You should see your instances being planned via `module.frontend_server.aws_instance...`.
3. Run `tf apply` and verify.
4. When finished, run `tf destroy`.

Let me know when you finish your module!
