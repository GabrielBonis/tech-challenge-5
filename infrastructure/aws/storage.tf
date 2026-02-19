### Buckets dos dados
resource "aws_s3_bucket" "buckets" {
  count  = length(var.bucket_names)
  bucket = "${local.prefix}-${var.bucket_names[count.index]}-${var.account}"
  tags   = local.common_tags
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.buckets[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.buckets[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # ou "aws:kms" se preferir KMS
    }
  }
}

resource "aws_s3_bucket_policy" "buckets_policy" {
  count  = length(var.bucket_names)
  bucket = aws_s3_bucket.buckets[count.index].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowAccountAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.account}:root" 
        },
        Action   = "s3:*",
        Resource = [
          "${aws_s3_bucket.buckets[count.index].arn}",
          "${aws_s3_bucket.buckets[count.index].arn}/*"
        ]
      }
    ]
  })
}