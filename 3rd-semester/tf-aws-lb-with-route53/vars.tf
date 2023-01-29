variable "db_name" {
  type = string
  default = "remote-backend-lock"
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "bucket_name" {
  type = string
  default = "remote-backend-s3"
}