resource "aws_s3_bucket" "tf_state_files" {
  bucket = var.bucket_name
  force_destroy = true
  tags = var.tags
}

resource "aws_dynamodb_table" "tf_state_locks" {
  count        = length(var.dynamo_db) > 0 ? 1 : 0
  name         = var.dynamo_db
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket                  = aws_s3_bucket.tf_state_files.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
