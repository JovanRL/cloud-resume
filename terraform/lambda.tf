data "archive_file" "lambda" {
  type          = "zip"
  source_file    = "../bootstrap"
  output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "go_lambda_counter" {

  function_name = "go_lambda_counter"
  role          = aws_iam_role.lambda_dynamo_role.arn
  handler       = "main.handler"
  filename       = "lambda_function.zip"

  runtime       = "provided.al2"
}