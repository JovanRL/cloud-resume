data "archive_file" "lambda" {
  type          = "zip"
  source_file    = "../bootstrap"
  output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "go_lambda_counter" {
  provider = aws.east
  function_name = "go_lambda_counter"
  role          = aws_iam_role.lambda_dynamo_role.arn
  handler       = "main.handler"
  filename       = "lambda_function.zip"

  runtime       = "provided.al2"
}

resource "aws_lambda_permission" "api_gateway" {
  provider = aws.east
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.go_lambda_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visits_api.execution_arn}/*/*"
}