resource "aws_iam_role" "lambda_dynamo_role" {
  name = "LambdaDynamoRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dynamo_policy" {
  name = "lambda_dynamo_policy"
  role = aws_iam_role.lambda_dynamo_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1428341300017",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:DescribeTable",
                "dynamodb:UpdateItem"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow"
        }
    ]
})
}
