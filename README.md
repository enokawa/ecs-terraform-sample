# ecs-terraform-sample

Terraform sample code to create Amazon ECS on AWS Fargate.

## Prerequisite

- [Terraform](https://www.terraform.io/)

## Usage

Set environment variable `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION`.

```sh
$ direnv edit . # direnv is not required
export AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_REGION=us-east-1
```

Modify S3 bucket settings for remote state on `terraform.tf`.

```hcl
terraform {
  required_version = "1.1.6"
  backend "s3" {
    bucket = "your-tfstate-bucket-name" # Enter your bucket name
    key    = "us-east-1/dev/terraform.tfstate"
    region = "us-east-1"
  }
.
.
.
```

Install Terraform binary and execute `terraform init`.

```sh
$ terraform init
```

## Apply

```sh
$ terraform plan
$ terraform apply
```

## Destroy

```sh
$ terraform destroy
```
