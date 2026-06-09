# Assignment 2: Migrating to the Cloud

## 🎯 Objective
Migrate your local Terraform state to a remote AWS S3 Backend using Native S3 Locking.

## 📝 Requirements

1. **Create the S3 Bucket manually via AWS CLI (or Console):**
   - Create an S3 bucket in `ap-south-1` (or `us-east-1`). Remember, bucket names must be globally unique!
   - *CRITICAL:* You must enable **Bucket Versioning** on this bucket, or native locking will not work.
   *(Hint: You can reference the `docs/s3-native-locking-guide.md` we created earlier for the exact CLI commands).*

2. **Write the Terraform Code:**
   - Create a `main.tf` in this directory.
   - Add your `provider` block.
   - Add a `terraform` block with a `backend "s3"` configuration.
   - Configure the backend to use your new bucket, set a key (e.g., `coursework/module2/terraform.tfstate`), and set `use_lockfile = true`.
   - Add the exact same `aws_instance` resource block from Assignment 1.

3. **Initialize and Apply:**
   - Run `terraform init`. You should see a message saying "Successfully configured the backend".
   - Run `terraform apply`.

4. **Verify the Lock (Optional but Fun):**
   - Open two terminal tabs.
   - Run `terraform apply` in Tab A (don't type yes).
   - Run `terraform apply` in Tab B. You should see an Error stating the state is locked!

## 🚦 Instructions
Open your terminal and `cd` into this directory:
```bash
cd coursework/02-state-management/assignment/
```

1. Create the S3 bucket using AWS CLI.
2. Write your `main.tf`.
3. Run `terraform init` and `terraform apply`.

## 🧑‍🏫 Evaluation
When you are done, log into your AWS Console and verify that the `terraform.tfstate` file is sitting in your S3 bucket!

Run `terraform destroy` when finished, and let me know here in the chat so I can review your `main.tf`!
