variable "name" {}
variable "environment" {}
variable "image_names" {}
variable "repository_name" {}
variable "enabled" { default = true }
variable "use_fullname" { default = false }
variable "min_image_count" { default = 2 }
variable "max_image_count" { default = 5 }
variable "tag_mutability" { default = "MUTABLE" }
variable "scan_images_on_push" { default = true }
variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = any
  })
  description = "ECR encryption configuration"
  default = {
    encryption_type = "KMS"
    kms_key         = null
  }
}
