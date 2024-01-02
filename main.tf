module "database_dynamodb" {
  source = "./modules/dynamodb"
}

module "api_gateway" {
  source = "./modules/api_gateway"
}

module "lambda_wallet" {
  source = "./modules/lambda_wallet"

  function_name = "wallet"
  entrypoint    = "bootstrap"

  zip_source_file = "../backend/out/bootstrap"
  zip_output_path = "../backend/out/"
  zip_file_name   = "lambda_backend_handler.zip"

  dynamodb_table_arn = module.database_dynamodb.dynamodb_table_arn

  APP_NAME            = "wallet"
  COGNITO_JWK_URL     = var.COGNITO_JWK_URL
  COGNITO_CLIENT_ID   = var.COGNITO_CLIENT_ID
  DYNAMODB_TABLE_NAME = var.DYNAMODB_TABLE_NAME
}

module "wallet_proxy" {
  source = "./modules/api_lambda"

  path_part = "wallet"

  lambda_function_name = module.lambda_wallet.lambda_function_name
  lambda_invoke_arn    = module.lambda_wallet.lambda_invoke_arn

  rest_api_execution_arn = module.api_gateway.rest_api_execution_arn
  rest_api_id            = module.api_gateway.rest_api_id
  rest_root_id           = module.api_gateway.root_resource_id
}

module "lambda_photos" {
  source = "./modules/lambda_photos"

  function_name = "photos"
  entrypoint    = "bootstrap"

  zip_source_file = "../backend/out/bootstrap"
  zip_output_path = "../backend/out"
  zip_file_name   = "lambda_backend_handler.zip"

  dynamodb_table_arn = module.database_dynamodb.dynamodb_table_arn
  s3_bucket_name     = var.S3_BUCKET_NAME

  function_url = false

  environment = {
    APP_NAME = "photos"

    COGNITO_JWK_URL   = var.COGNITO_JWK_URL
    COGNITO_CLIENT_ID = var.COGNITO_CLIENT_ID

    DYNAMODB_TABLE_NAME = var.DYNAMODB_TABLE_NAME
    BUCKET_NAME         = var.S3_BUCKET_NAME
  }
}

module "photos_proxy" {
  source = "./modules/api_lambda"

  path_part = "photos"

  lambda_function_name = module.lambda_photos.lambda_function_name
  lambda_invoke_arn    = module.lambda_photos.lambda_invoke_arn

  rest_api_execution_arn = module.api_gateway.rest_api_execution_arn
  rest_api_id            = module.api_gateway.rest_api_id
  rest_root_id           = module.api_gateway.root_resource_id
}

module "lambda_auth3" {
  source = "./modules/lambda_auth3"

  function_name = "auth3"
  entrypoint    = "bootstrap"

  zip_source_file = "../backend/out/bootstrap"
  zip_output_path = "../backend/out"
  zip_file_name   = "lambda_backend_handler.zip"

  environment = {
    APP_NAME          = "auth3"
    COGNITO_CLIENT_ID = var.COGNITO_CLIENT_ID
  }
}

module "auth3_proxy" {
  source = "./modules/api_lambda"

  path_part = "auth3"

  lambda_function_name = module.lambda_auth3.lambda_function_name
  lambda_invoke_arn    = module.lambda_auth3.lambda_invoke_arn

  rest_api_execution_arn = module.api_gateway.rest_api_execution_arn
  rest_api_id            = module.api_gateway.rest_api_id
  rest_root_id           = module.api_gateway.root_resource_id
}

module "lambda_buck3t" {
  source = "./modules/lambda_buck3t"

  function_name = "buck3t"
  entrypoint    = "bootstrap"

  zip_source_file = "../backend/out/bootstrap"
  zip_output_path = "../backend/out"
  zip_file_name   = "lambda_backend_handler.zip"

  s3_bucket_name = var.S3_BUCKET_NAME

  environment = {
    BUCKET_NAME     = var.S3_BUCKET_NAME
  }
}

module "buck3t_proxy" {
  source = "./modules/api_lambda"

  path_part = "buck3t"

  lambda_function_name = module.lambda_buck3t.lambda_function_name
  lambda_invoke_arn    = module.lambda_buck3t.lambda_invoke_arn

  rest_api_execution_arn = module.api_gateway.rest_api_execution_arn
  rest_api_id            = module.api_gateway.rest_api_id
  rest_root_id           = module.api_gateway.root_resource_id
}

module "lambda_auth4" {
  source = "./modules/lambda_auth4"

  function_name = "auth4"
  entrypoint    = "bootstrap"

  zip_source_file = "../backend/out/bootstrap"
  zip_output_path = "../backend/out"
  zip_file_name   = "lambda_backend_handler.zip"

  environment = {
    COGNITO_JWK_URL = var.COGNITO_JWK_URL
  }
}
