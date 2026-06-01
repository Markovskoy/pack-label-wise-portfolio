output "frontend_bucket_name" {
  value = module.frontend_bucket.s3_bucket_id
}

output "backup_bucket_name" {
  value = module.backup_bucket.s3_bucket_id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "app_instance_id" {
  value = module.app_host.id
}

output "deploy_policy_arn" {
  value = aws_iam_policy.deploy.arn
}
