variable "name" {
  description = "The name of the API Gateway"
}
variable "region" {
  description = "The AWS region in which resources are created"
}
variable "environment" {
  description = "The environment name to be used in resource names"
}
variable "enable_custom_domain" {
  type        = bool
  description = "Whether to enable custom domain for the API Gateway"
  default     = false
}
variable "domain_name" {
  description = "The custom domain name"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate in ACM"
  type        = string
  default     = ""
}
variable "routes" {
  description = "Map of routes for the API Gateway"
  type = map(object({
    route_key       = string
    integration_key = string
  }))
  default = {}
}
variable "integrations" {
  type = list(object({
    sqs_url     = string
    sqs_arn     = string
    route_key   = string
    description = string
  }))
}
