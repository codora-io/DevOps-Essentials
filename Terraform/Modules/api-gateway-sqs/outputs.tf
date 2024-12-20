output "domain_name" {
  value = var.enable_custom_domain ? aws_apigatewayv2_domain_name.custom_domain[0].domain_name : null
}

output "api_gw_domain_name_configuration" {
  value = var.enable_custom_domain ? aws_apigatewayv2_domain_name.custom_domain[0].domain_name_configuration[0].target_domain_name : null
}