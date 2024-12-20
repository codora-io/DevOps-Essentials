data "aws_caller_identity" "current" {}

resource "random_id" "suffix" {
  byte_length = 2
}

# API Gateway V2 HTTP API
resource "aws_apigatewayv2_api" "main" {
  name          = var.name
  protocol_type = "HTTP"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "main_api_gw" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.main.name}-${random_id.suffix.hex}"
  retention_in_days = 7
}

resource "aws_apigatewayv2_integration" "integration" {
  for_each = { for i, v in var.integrations : i => v }

  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_subtype    = "SQS-SendMessage"
  connection_type        = "INTERNET"
  description            = each.value.description
  payload_format_version = "1.0"
  credentials_arn        = aws_iam_role.apigw_sqs_role.arn

  request_parameters = {
    "QueueUrl"    = each.value.sqs_url
    "MessageBody" = "$request.body.message"
  }
}

resource "aws_apigatewayv2_route" "route" {
  for_each = { for i, v in var.integrations : i => v }

  api_id    = aws_apigatewayv2_api.main.id
  route_key = each.value.route_key

  target = "integrations/${aws_apigatewayv2_integration.integration[each.key].id}"
}

# Stage
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.main_api_gw.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

# Custom Domain Name for HTTP API
resource "aws_apigatewayv2_domain_name" "custom_domain" {
  count = var.enable_custom_domain ? 1 : 0

  domain_name = var.domain_name
  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

# Base Path Mapping for HTTP API
resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  count = var.enable_custom_domain ? 1 : 0

  api_id      = aws_apigatewayv2_api.main.id
  stage       = aws_apigatewayv2_stage.main.name
  domain_name = aws_apigatewayv2_domain_name.custom_domain[0].domain_name
}

# SQS Permissions for API Gateway
resource "aws_iam_role" "apigw_sqs_role" {
  name = join("", [var.name, "-", var.environment, "-", "apigw-sqs-role", "-", random_id.suffix.hex])
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      },
      Action   = "sts:AssumeRole"
    }]
  })
  tags = {
    Name        = join("", [var.name, "-", var.environment, "-", "apigw-sqs-role", "-", random_id.suffix.hex])
    Environment = var.environment
    Terraform   = "yes"
  }
}

resource "aws_iam_policy" "apigw_sqs_policy" {
  for_each = { for idx, integration in var.integrations : integration.sqs_arn => integration }

  name = join("", [
    var.name,
    "-",
    var.environment,
    "-",
    "apigw-sqs-policy-",
    element(split(":", each.key), length(split(":", each.key)) - 1)
  ])

  description = "IAM policy for API Gateway to send messages to SQS"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = each.value.sqs_arn
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "apigw_sqs_policy_attachment" {
  for_each   = aws_iam_policy.apigw_sqs_policy

  role       = aws_iam_role.apigw_sqs_role.name
  policy_arn = each.value.arn
}
