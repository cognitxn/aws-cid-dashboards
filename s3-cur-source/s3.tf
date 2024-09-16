resource "aws_s3_bucket" "source" {
  bucket        = local.bucket_name
  force_destroy = var.enable_force_destroy
  tags          = local.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "source" {
  bucket = aws_s3_bucket.source.bucket
  rule {
    id     = "ExpireObjects&NonCurrentVersions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration
    }
    expiration {
      days                         = var.object_expiration_days
      expired_object_delete_marker = true
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}

resource "aws_s3_bucket_logging" "source" {
  count = var.s3_access_logging.enabled ? 1 : 0

  bucket        = aws_s3_bucket.source.bucket
  target_bucket = var.s3_access_logging.bucket
  target_prefix = var.s3_access_logging.prefix
}

resource "aws_s3_bucket_ownership_controls" "source" {
  bucket = aws_s3_bucket.source.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "source" {
  bucket = aws_s3_bucket.source.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

resource "aws_s3_bucket_public_access_block" "source" {
  bucket                  = aws_s3_bucket.source.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.source]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id     = "ReplicationRule1"
    status = "Enabled"
    filter {
      prefix = "cur/${local.account_id}"
    }
    delete_marker_replication {
      status = "Enabled"
    }
    destination {
      bucket        = var.destination_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source" {
  bucket = aws_s3_bucket.source.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.bucket
  versioning_configuration {
    status = "Enabled"
  }
}


