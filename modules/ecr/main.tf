#####################################
# AWS ECR Module
#####################################
module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.38.0"

  name                     = var.repository_name
  enabled                  = var.enabled
  image_names              = var.image_names
  use_fullname             = var.use_fullname
  max_image_count          = var.max_image_count
  attributes               = ["ecr"]
  scan_images_on_push      = var.scan_images_on_push
  image_tag_mutability     = var.tag_mutability
  principals_full_access   = []
  encryption_configuration = var.encryption_configuration

  tags = {
    Name        = join("", [var.name, "-", var.environment, "-", var.repository_name, "-ecr"])
    Environment = var.environment
    Terraform   = "yes"
  }
}

# ECR Lifecycle Policy Settings
resource "aws_ecr_lifecycle_policy" "main" {
  repository = module.ecr.repository_name

  policy = jsonencode({
    rules = [{
      action       = { type = "expire" }
      description  = "keep last 5 images"
      rulePriority = 1
      selection = {
        countNumber = var.min_image_count
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })
}
