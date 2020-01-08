data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda.zip"

  source {
    content  = file("lambda/checkup.py")
    filename = "checkup.py"
  }

  source {
    content = templatefile("lambda/checkup.json", {
      access_key_id     = aws_iam_access_key.admin.id,
      secret_access_key = aws_iam_access_key.admin.secret,
      bucket            = var.url,
      region            = var.aws_region,
    })
    filename = "checkup.json"
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda" {
  name = "checkup_for_${replace(var.url, ".", "-dot-")}-role"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "random_uuid" "lambda" {}

resource "aws_iam_policy" "lambda" {
  name = "AWSLambdaBasicExecutionRole-${random_uuid.lambda.result}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/checkup_for_${replace(var.url, ".", "-dot-")}:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_lambda_function" "checkup" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "checkup_for_${replace(var.url, ".", "-dot-")}"
  role             = aws_iam_role.lambda.arn
  handler          = "checkup.run"
  layers           = [aws_lambda_layer_version.checkup.arn]
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.8"
}