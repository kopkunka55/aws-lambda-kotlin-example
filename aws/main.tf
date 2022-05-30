provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "kotlin_lambda" {
  filename      = "./../build/libs/aws-lambda-kotlin-1.0-SNAPSHOT.jar"
  function_name = "kotlin-lambda-ddb-event-handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "Main::handler"

  source_code_hash = filebase64sha256("./../build/libs/aws-lambda-kotlin-1.0-SNAPSHOT.jar")

  runtime = "java11"
  publish = true

}

module "alias_refresh" {
  source = "terraform-aws-modules/lambda/aws//modules/alias"

  name          = "current-with-refresh"
  function_name = aws_lambda_function.kotlin_lambda.function_name

  # Set function_version when creating alias to be able to deploy using it,
  # because AWS CodeDeploy doesn't understand $LATEST as CurrentVersion.
  function_version = aws_lambda_function.kotlin_lambda.version
}

module "deploy" {
  source = "terraform-aws-modules/lambda/aws//modules/deploy"

  alias_name    = module.alias_refresh.lambda_alias_name
  function_name = aws_lambda_function.kotlin_lambda.function_name

  target_version = aws_lambda_function.kotlin_lambda.version

  create_app = true
  app_name   = "kotlin-lambda"

  create_deployment_group = true
  deployment_group_name   = "dev"

  create_deployment          = true
  run_deployment             = true
  wait_deployment_completion = false
  deployment_config_name = "CodeDeployDefault.LambdaCanary10Percent5Minutes"
  depends_on = [module.alias_refresh]
}