output "frontend_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}

output "cloudfront_distribution_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.frontend.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}

output "deploy_policy_arn" {
  value = aws_iam_policy.deploy.arn
}
