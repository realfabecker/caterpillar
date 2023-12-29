variable "COGNITO_CLIENT_ID" {
  type = string
}

variable "COGNITO_JWK_URL" {
  type    = string
  default = ""
}

variable "DYNAMODB_TABLE_NAME" {
  type    = string
  default = ""
}

variable "S3_BUCKET_NAME" {
  type    = string
  default = ""
}