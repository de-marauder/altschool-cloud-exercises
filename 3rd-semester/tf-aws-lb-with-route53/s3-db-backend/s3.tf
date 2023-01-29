resource "aws_s3_bucket" "s3-backend" {
  bucket = var.bucket_name

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Add ACL rule
resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.s3-backend.id
  acl    = "private"
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.s3-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
# Enable KMS encryption
# resource "aws_kms_key" "s3-backend-kms-key" {
#   description             = "This key is used to encrypt tf backend bucket objects"
#   deletion_window_in_days = 10
# }

resource "aws_s3_bucket_server_side_encryption_configuration" "s3-backend-key-sse" {
  bucket = aws_s3_bucket.s3-backend.bucket

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = aws_kms_key.s3-backend-kms-key.arn
      sse_algorithm = "aws:kms"
    }

    bucket_key_enabled = true
  }
}

# Modify bucket policy

resource "aws_s3_bucket_policy" "tf-backend-policy" {
  bucket = aws_s3_bucket.s3-backend.id
  policy = data.aws_iam_policy_document.tf-backend-policy-doc.json
}

data "aws_iam_policy_document" "tf-backend-policy-doc" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }

    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3-backend.arn,
      "${aws_s3_bucket.s3-backend.arn}/*",
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3-backend.arn,
      "${aws_s3_bucket.s3-backend.arn}/*",
    ]
  }
}
