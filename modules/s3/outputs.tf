output "bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "Bucket ID"
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Bucket ARN"
}

output "bucket_region" {
  value       = module.s3_bucket.bucket_region
  description = "Bucket region"
}

output "user_name" {
  value       = module.s3_bucket.user_name
  description = "Normalized IAM user name"
}

output "user_arn" {
  value       = module.s3_bucket.user_arn
  description = "The ARN assigned by AWS for the user"
}

output "user_unique_id" {
  value       = module.s3_bucket.user_unique_id
  description = "The user unique ID assigned by AWS"
}
output "access_key_id" {
  sensitive   = true
  value       = try(coalesce(module.s3_bucket.access_key_id), "")
  description = "Access Key ID"
}
output "secret_access_key" {
  sensitive   = true
  value       = try(coalesce(module.s3_bucket.secret_access_key), "")
  description = "Secret Access Key. This will be written to the state file in plain-text"
}
