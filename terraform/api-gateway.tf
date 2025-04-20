resource "aws_apigatewayv2_api" "visits_api" {
  provider = aws.east
  name                       = "visits-api"
  protocol_type              = "HTTP"

    cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "GET"]
    allow_headers = ["Content-Type", "Access-Control-Allow-Origin"]
    max_age = 300
  }
}

resource "aws_apigatewayv2_stage" "staging" {
  provider = aws.east
  name   = "staging"
  api_id = aws_apigatewayv2_api.visits_api.id
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "api_lambda_integration" {
  provider = aws.east
  api_id           = aws_apigatewayv2_api.visits_api.id
  integration_type = "AWS_PROXY"

  integration_method        = "POST"
  integration_uri           = aws_lambda_function.go_lambda_counter.invoke_arn
}

resource "aws_apigatewayv2_route" "endpoint_visits" {
  provider = aws.east
  api_id    = aws_apigatewayv2_api.visits_api.id
  route_key = "ANY /visits"

  target = "integrations/${aws_apigatewayv2_integration.api_lambda_integration.id}"
}

resource "aws_apigatewayv2_domain_name" "api_custom_domain" {
  provider = aws.east
  domain_name = var.api_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.certificate_request_api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  provider = aws.east

  api_id      = aws_apigatewayv2_api.visits_api.id
  domain_name = aws_apigatewayv2_domain_name.api_custom_domain.id
  stage       = aws_apigatewayv2_stage.staging.id
}

output "custom_domain_api" {
  value = "https://${aws_apigatewayv2_api_mapping.api_mapping.domain_name}"
}