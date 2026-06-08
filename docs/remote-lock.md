# Terraform Remote State & Locking

A remote backend solves the problem of working with Terraform in a team environment. If multiple people are deploying infrastructure, relying on a local `terraform.tfstate` file on individual laptops is dangerous. It leads to constantly overwriting each other's changes, resulting in duplicated resources, deleted resources, and corrupted state.

A remote backend moves that state file into a centralized, shared storage system (like an AWS S3 Bucket) so everyone has a single source of truth.

However, if two engineers run `terraform apply` at the exact same second, they could corrupt that shared file. To prevent this, Terraform uses **State Locking**. When an operation starts, Terraform "locks" the state. Anyone else who tries to run a command will get an error saying, *"State is locked by User A, please wait."*

Here is an explanation of the two primary locking methods and how they are used in the enterprise world:

## 1. The Classic Method: S3 + DynamoDB Locking
For years, Amazon S3 did not have a built-in way to guarantee that two people couldn't overwrite a file at the exact same time (it lacked "conditional writes"). Because of this, Terraform had to use a separate database just to handle the lock.

- **How it works:** You create an S3 bucket to hold the `terraform.tfstate` file, and a DynamoDB table with a specific partition key (usually `LockID`).
- **The Flow:** When you run `terraform apply`, Terraform first writes an entry to the DynamoDB table saying "I have the lock." It then does its work, updates the S3 file, and finally deletes the entry from DynamoDB. If another user tries to apply, Terraform checks DynamoDB, sees the lock entry, and blocks them.

## 2. The Modern Method: S3 Native Locking (Without DynamoDB)
In August 2024, AWS updated S3 to support "conditional writes". This meant S3 could finally natively handle locking without needing an external database. Shortly after (in Terraform v1.10), HashiCorp updated Terraform to support **S3 Native State Locking**.

- **How it works:** You no longer need to create or pay for a DynamoDB table! You only provide the S3 bucket.
- **The Flow:** Terraform uses a new parameter `use_lockfile = true`. When you run an apply, Terraform writes a `.tflock` file directly into S3 using a conditional write. S3 guarantees that only one person can create this lock file at a time. Once the apply is done, Terraform deletes the lock file.

## Which one is used in MNCs (Multinational Corporations)?
Right now, almost all MNCs use the classic **S3 + DynamoDB method**.

Here is why:
- **Legacy and Stability:** Enterprises move slowly. They have massive, complex CI/CD pipelines and thousands of Terraform repositories that were built years ago using the DynamoDB method. It is incredibly stable and has been battle-tested for over 8 years.
- **Version Lags:** MNCs rarely run the bleeding-edge version of Terraform. Native S3 locking is very new (late 2024 / Terraform v1.10+). Many enterprises are still running Terraform v1.5, v1.6, or even older versions that do not support S3 native locking yet.

**The Future:** HashiCorp has officially stated that the DynamoDB locking method is now considered *deprecated*. Over the next 1-3 years, as MNCs upgrade their Terraform versions and refactor their backend configurations, you will see a massive industry shift where everyone moves to **S3 Native Locking** because it is cheaper, requires less IAM permission management, and results in cleaner code.