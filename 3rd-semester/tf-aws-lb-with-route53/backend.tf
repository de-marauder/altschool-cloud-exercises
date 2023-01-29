module "backend" {
  source = "./s3-db-backend"

  # s3 params
  bucket_name = var.bucket_name
  # db params
  db_name = var.db_name
  # region
  aws_region = var.region

}
