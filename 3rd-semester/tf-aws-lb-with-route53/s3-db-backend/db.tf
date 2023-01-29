resource "aws_dynamodb_table" "db-backend" {
  name           = var.db_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "tf-${var.db_name}"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}