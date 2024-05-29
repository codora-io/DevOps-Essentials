variable "bucket_name" {}
variable "environment" {}
variable "acl" {
  type    = string
  default = "private"
}
variable "enabled" {}
variable "user_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to create an IAM user with permission to access the bucket"
  nullable    = false
}
variable "force_destroy" {}
variable "versioning_enabled" {
  type    = bool
  default = false
}
variable "block_public_acls" {
  type    = bool
  default = true
}
variable "allow_encrypted_uploads_only" {
  type    = bool
  default = true
}
variable "block_public_policy" {
  type    = bool
  default = true
}
variable "ignore_public_acls" {
  type    = bool
  default = true
}
variable "allowed_bucket_cors" {}
variable "sse_algorithm" {
  type    = string
  default = "AES256"
}
variable "allowed_bucket_actions" {
  type        = list(string)
  default     = []
  description = "List of actions the user is permitted to perform on the S3 bucket"
  nullable    = false
}
variable "lifecycle_configuration_rules" {
  type    = list(any)
  default = []
}
variable "allow_ssl_requests_only" {
  type    = bool
  default = true
}
variable "deployment_circuit_breaker_rollback" {
  description = "(Optional) The optional rollback option causes Amazon ECS to roll back to the last completed deployment upon a deployment failure."
  type        = bool
  default     = false
}
variable "iam_role_enabled" {
  description = "Enable SSL"
  type        = bool
  default     = true
}
variable "iam_policy_enabled" {
  description = "Enable SSL"
  type        = bool
  default     = true
}
variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the restricting of making the bucket public"
  nullable    = false
}
variable "privileged_principal_arns" {
  #  type        = map(list(string))
  #  default     = {}
  type        = list(map(list(string)))
  default     = []
  description = <<-EOT
    List of maps. Each map has a key, an IAM Principal ARN, whose associated value is
    a list of S3 path prefixes to grant `privileged_principal_actions` permissions for that principal,
    in addition to the bucket itself, which is automatically included. Prefixes should not begin with '/'.
    EOT
  nullable    = false
}
variable "privileged_principal_actions" {
  type        = list(string)
  default     = []
  description = "List of actions to permit `privileged_principal_arns` to perform on bucket and bucket prefixes (see `privileged_principal_arns`)"
  nullable    = false
}
variable "access_log_bucket_name" {
  type    = string
  default = ""
}
variable "access_log_bucket_prefix" {
  type    = string
  default = "s3logs"
}
