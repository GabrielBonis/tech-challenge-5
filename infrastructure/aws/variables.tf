variable "region_id" {
  default = "us-east-1"
}

variable "prefix" {
  default = "tech-challanger-5"
}

variable "account" {
  default = 851725318853
}

# Prefix configuration and project common tags
locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Project      = "tech-challanger-5"
    ManagedBy    = "Terraform"
    Department   = "TI",
    Provider     = "students",
    Owner        = "Data Engineering"
    BusinessUnit = "Data"
    Billing      = "Infrastructure"
    Environment  = terraform.workspace
    UserEmail    = "gabrieldebonis@gmail.com"
  }
}

variable "bucket_names" {
  description = "Create S3 buckets with these names"
  type        = list(string)
  default = [
    "raw-zone",
    "delivery-zone"
  ]
}

variable "database_names" {
  description = "Create databases with these names"
  type        = list(string)
  default = [
    #landing-zone
    "dl-raw-zone",
    "dl-delivery-zone"
  ]
}
