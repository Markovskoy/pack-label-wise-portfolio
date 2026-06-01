variable "project_name" {
  type    = string
  default = "labelmaster"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-2"
}

variable "app_domain" {
  type    = string
  default = "<app-domain>"
}

variable "api_domain" {
  type    = string
  default = "<api-domain>"
}

variable "frontend_bucket_name" {
  type    = string
  default = "<frontend-bucket-name>"
}

variable "backup_bucket_name" {
  type    = string
  default = "<backup-bucket-name>"
}

variable "cloudfront_certificate_arn" {
  type    = string
  default = "arn:aws:acm:us-east-1:<aws-account-id>:certificate/<certificate-id>"
}

variable "route53_zone_id" {
  type    = string
  default = "<route53-zone-id>"
}

variable "api_public_ip" {
  type    = string
  default = "<elastic-ip>"
}

variable "vpc_id" {
  type    = string
  default = "<vpc-id>"
}

variable "subnet_id" {
  type    = string
  default = "<subnet-id>"
}

variable "admin_cidrs" {
  type    = list(string)
  default = ["<office-cidr>"]
}

variable "ec2_ami_id" {
  type    = string
  default = "<ami-id>"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.large"
}

variable "ec2_key_name" {
  type    = string
  default = "<ec2-key-name>"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
